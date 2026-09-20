import 'package:sun_shine/core.dart';

/// Stands in for the retrofit client so tests never touch the network.
class FakeAuthApiClient implements AuthApiClient {
  FakeAuthApiClient({this.signInResult, this.profileResult});

  Result<SessionApiModel>? signInResult;
  Result<UserApiModel>? profileResult;

  AuthRequest? lastRequest;
  int signOutCount = 0;

  @override
  Future<Result<SessionApiModel>> signIn(AuthRequest request) async {
    lastRequest = request;
    return signInResult ??
        const Result.ok(
          SessionApiModel(
            token: 'tok',
            user: UserApiModel(id: 'u1', email: 'khai@sunshine.com'),
          ),
        );
  }

  @override
  Future<Result<UserApiModel>> getMyProfile() async =>
      profileResult ??
      const Result.ok(UserApiModel(id: 'u1', email: 'khai@sunshine.com'));

  @override
  Future<Result<void>> signOut() async {
    signOutCount++;
    return const Result.ok(null);
  }
}
