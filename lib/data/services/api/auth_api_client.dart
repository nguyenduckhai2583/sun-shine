/// One class per external dependency. This is the seam the app would talk
/// HTTP through — for now it just answers with canned data.
class AuthApiClient {
  Future<Map<String, Object?>> signIn({
    required String email,
    required String password,
  }) async => {
    'id': 'u-1',
    'full_name': email.split('@').first,
    'email': email,
  };
}
