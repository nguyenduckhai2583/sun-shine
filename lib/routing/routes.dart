/// Paths are the source of truth, kept in one place so no call site
/// hard-codes a string.
abstract final class Routes {
  static const signIn = '/sign-in';

  static const students = '/students';
  static const teachers = '/teachers';

  /// Relative segments, as declared inside the parent route's `routes:`.
  static const studentDetailRelative = ':studentId';
  static const teacherDetailRelative = ':teacherId';

  static String studentDetail(String id) => '$students/$id';

  static String teacherDetail(String id) => '$teachers/$id';
}
