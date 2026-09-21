class AuthRequest {
  const AuthRequest({required this.email, required this.sha1Password});

  final String email;
  final String sha1Password;

  Map<String, dynamic> toJson() => {'email': email, 'password': sha1Password};
}
