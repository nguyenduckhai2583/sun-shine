class TeacherApiClient {
  static const _teachers = <Map<String, Object?>>[
    {
      'id': 't-1',
      'full_name': 'Mai Hoang',
      'email': 'mai.hoang@sunshine.edu',
      'subject': 'Mathematics',
      'years_of_experience': 12,
    },
    {
      'id': 't-2',
      'full_name': 'Khai Nguyen',
      'email': 'khai.nguyen@sunshine.edu',
      'subject': 'Physics',
      'years_of_experience': 8,
    },
    {
      'id': 't-3',
      'full_name': 'Lan Dao',
      'email': 'lan.dao@sunshine.edu',
      'subject': 'Literature',
      'years_of_experience': 15,
    },
    {
      'id': 't-4',
      'full_name': 'Son Bui',
      'email': 'son.bui@sunshine.edu',
      'subject': 'English',
      'years_of_experience': 5,
    },
  ];

  Future<List<Map<String, Object?>>> fetchTeachers() async => _teachers;

  Future<Map<String, Object?>> fetchTeacher(String id) async =>
      _teachers.firstWhere((teacher) => teacher['id'] == id);
}
