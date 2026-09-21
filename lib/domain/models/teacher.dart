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
}
