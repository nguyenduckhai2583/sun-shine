import '../../domain/models/student.dart';

abstract class StudentRepository {
  /// Every consumer reads the same stream, so one write reaches all of them.
  Stream<List<Student>> get students;

  Stream<Student?> watchStudent(String id);

  Future<void> loadStudents();

  Future<void> loadStudent(String id);
}
