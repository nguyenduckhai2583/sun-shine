/// The sign-in request body.
///
/// The password is SHA1-salted on the client before it leaves, and the server
/// expects that digest under the key `password`.
class AuthRequest {
  const AuthRequest({required this.email, required this.sha1Password});

  final String email;
  final String sha1Password;

  Map<String, dynamic> toJson() => {'email': email, 'password': sha1Password};
}
