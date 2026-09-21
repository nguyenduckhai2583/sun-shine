import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_session_repository.dart';
import '../testing/fakes/fake_token_refresh_api_client.dart';
import '../testing/fakes/fake_workspace_repository.dart';

void main() {
  group('SelectWorkspaceUseCase', () {
    const khai = Session(userId: 'u1', token: 't1', workspaceId: 'w1');
    const linh = Session(userId: 'u2', token: 't2', workspaceId: 'w9');

    late FakeSessionRepository sessions;
    late FakeWorkspaceRepository workspaces;
    late FakeTokenRefreshApiClient tokenRefresh;
    late SelectWorkspaceUseCase useCase;

    setUp(() {
      sessions = FakeSessionRepository();
      workspaces = FakeWorkspaceRepository();
      tokenRefresh = FakeTokenRefreshApiClient();
      useCase = SelectWorkspaceUseCase(
        sessionRepository: sessions,
        switchAccountUseCase: SwitchAccountUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
          tokenRefreshApiClient: tokenRefresh,
        ),
      );
      addTearDown(sessions.dispose);
      addTearDown(workspaces.dispose);
    });

    test('assigns a workspace of the active account', () async {
      sessions.emit(khai);

      final result = await useCase.execute(
        accountUserId: 'u1',
        workspaceId: 'w2',
      );

      expect(result, isA<Ok<Session>>());
      expect(sessions.currentSession?.workspaceId, 'w2');
    });

    test(
      'switches account first when the workspace belongs elsewhere',
      () async {
        sessions.emitAll([khai, linh], activeUserId: 'u1');

        final result = await useCase.execute(
          accountUserId: 'u2',
          workspaceId: 'w9',
        );

        expect(result, isA<Ok<Session>>());
        expect(sessions.currentSession?.userId, 'u2');
        expect(sessions.currentSession?.workspaceId, 'w9');
      },
    );

    test('leaves the active account alone when the switch fails', () async {
      sessions.emitAll([
        khai,
        const Session(
          userId: 'u2',
          token: 'stale',
          refreshToken: 'r2',
          expireAt: 1,
        ),
      ], activeUserId: 'u1');
      tokenRefresh.failure = Exception('revoked');

      final result = await useCase.execute(
        accountUserId: 'u2',
        workspaceId: 'w9',
      );

      expect(result, isA<Error<Session>>());
      expect(sessions.currentSession?.userId, 'u1');
      expect(sessions.currentSession?.workspaceId, 'w1');
    });
  });
}
