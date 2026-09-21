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
}
