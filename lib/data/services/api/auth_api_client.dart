/// One class per external dependency. This is the seam the app would talk
/// HTTP through.
///
/// It is registered in the DI container by this *abstract* type, so swapping
/// [FakeAuthApiClient] for a Dio-backed client is a one-line change in
/// `main.dart` and nothing above this layer notices.
abstract class AuthApiClient {
  Future<Map<String, Object?>> signIn({
    required String email,
    required String password,
  });
}

/// Fake data, real shape: the client speaks JSON, exactly like the real one.
class FakeAuthApiClient implements AuthApiClient {
  @override
  Future<Map<String, Object?>> signIn({
    required String email,
    required String password,
  }) async => {
    'id': 'u-1',
    'full_name': email.split('@').first,
    'email': email,
  };
}
