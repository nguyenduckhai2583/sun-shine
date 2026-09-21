import '../../domain/models/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();

  Future<Student> getStudent(String id);
}
