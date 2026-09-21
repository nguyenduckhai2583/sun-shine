import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_session_repository.dart';
import '../testing/fakes/fake_token_refresh_api_client.dart';
import '../testing/fakes/fake_workspace_repository.dart';

void main() {
  group('SwitchAccountUseCase', () {
    const khai = Session(userId: 'u1', token: 't1', workspaceId: 'w1');

    late FakeSessionRepository sessions;
    late FakeWorkspaceRepository workspaces;
    late FakeTokenRefreshApiClient tokenRefresh;
    late SwitchAccountUseCase useCase;

    setUp(() {
      sessions = FakeSessionRepository();
      workspaces = FakeWorkspaceRepository();
      tokenRefresh = FakeTokenRefreshApiClient();
      useCase = SwitchAccountUseCase(
        sessionRepository: sessions,
        workspaceRepository: workspaces,
        tokenRefreshApiClient: tokenRefresh,
      );
      addTearDown(sessions.dispose);
      addTearDown(workspaces.dispose);
    });

    Session expired({String userId = 'u2', String? refreshToken = 'r2'}) =>
        Session(
          userId: userId,
          token: 'stale',
          refreshToken: refreshToken,
          expireAt: 1,
        );

    test('fails for an account that is not signed in', () async {
      sessions.emit(khai);

      final result = await useCase.execute('nobody');

      expect(result, isA<Error<Session>>());
    });

    test('is a no-op for the account already active', () async {
      sessions.emit(khai);

      final result = await useCase.execute('u1');

      expect(result, isA<Ok<Session>>());
      expect(tokenRefresh.refreshTokens, isEmpty);
    });

    test('switches without a network call while the token is good', () async {
      sessions.emitAll([
        khai,
        const Session(userId: 'u2', token: 't2'),
      ], activeUserId: 'u1');

      final result = await useCase.execute('u2');

      expect(result, isA<Ok<Session>>());
      expect(sessions.currentSession?.userId, 'u2');
      expect(tokenRefresh.refreshTokens, isEmpty);
    });

    test('renews an expired token before switching', () async {
      sessions.emitAll([khai, expired()], activeUserId: 'u1');
      tokenRefresh.response = const SessionApiModel(
        token: 'fresh',
        refreshToken: 'r2-next',
        expireAt: 9999999999,
      );

      final result = await useCase.execute('u2');

      expect(result, isA<Ok<Session>>());
      expect(tokenRefresh.refreshTokens, ['r2']);
      expect(sessions.currentSession?.userId, 'u2');
      expect(sessions.currentSession?.token, 'fresh');
    });

    test('drops the account when the renew fails', () async {
      sessions.emitAll([khai, expired()], activeUserId: 'u1');
      tokenRefresh.failure = Exception('revoked');

      final result = await useCase.execute('u2');

      expect(result, isA<Error<Session>>());
      expect(sessions.removed, ['u2']);
      expect(workspaces.removedAccounts, ['u2']);
      expect(sessions.currentSession?.userId, 'u1');
    });

    test('drops an expired account that has no refresh token', () async {
      sessions.emitAll([khai, expired(refreshToken: null)], activeUserId: 'u1');

      final result = await useCase.execute('u2');

      expect(result, isA<Error<Session>>());
      expect(tokenRefresh.refreshTokens, isEmpty);
      expect(sessions.removed, ['u2']);
    });
  });
}
