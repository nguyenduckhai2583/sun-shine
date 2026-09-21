/// A teacher, as the UI speaks about it.
class Teacher {
  const Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.yearsOfExperience,
  });

  final String id;
  final String name;
  final String email;
  final String subject;
  final int yearsOfExperience;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Teacher &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.subject == subject &&
          other.yearsOfExperience == yearsOfExperience;

  @override
  int get hashCode => Object.hash(id, name, email, subject, yearsOfExperience);
}
