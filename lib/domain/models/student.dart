/// A student, as the UI speaks about it.
///
/// Domain models know nothing about JSON — the repository maps the wire
/// format onto this class.
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.className,
    required this.gpa,
  });

  final String id;
  final String name;
  final String email;
  final String className;
  final double gpa;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.className == className &&
          other.gpa == gpa;

  @override
  int get hashCode => Object.hash(id, name, email, className, gpa);
}
