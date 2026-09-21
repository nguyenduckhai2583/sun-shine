import '../../domain/models/teacher.dart';

abstract class TeacherRepository {
  Stream<List<Teacher>> get teachers;

  Stream<Teacher?> watchTeacher(String id);

  Future<void> loadTeachers();

  Future<void> loadTeacher(String id);
}
