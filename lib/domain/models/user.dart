/// The signed-in user, as the UI speaks about it.
class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.name == name &&
          other.email == email;

  @override
  int get hashCode => Object.hash(id, name, email);
}
