import '../../domain/models/teacher.dart';

abstract class TeacherRepository {
  Future<List<Teacher>> getTeachers();

  Future<Teacher> getTeacher(String id);
}
