/// Fake data, real shape: the client speaks JSON, exactly like a real one
/// would, so the repository's mapping is the same either way.
class StudentApiClient {
  static const _students = <Map<String, Object?>>[
    {
      'id': 's-1',
      'full_name': 'An Nguyen',
      'email': 'an.nguyen@sunshine.edu',
      'class_name': '10A1',
      'gpa': 8.7,
    },
    {
      'id': 's-2',
      'full_name': 'Binh Tran',
      'email': 'binh.tran@sunshine.edu',
      'class_name': '10A1',
      'gpa': 7.9,
    },
    {
      'id': 's-3',
      'full_name': 'Chi Pham',
      'email': 'chi.pham@sunshine.edu',
      'class_name': '11B2',
      'gpa': 9.1,
    },
    {
      'id': 's-4',
      'full_name': 'Dung Le',
      'email': 'dung.le@sunshine.edu',
      'class_name': '11B2',
      'gpa': 8.2,
    },
    {
      'id': 's-5',
      'full_name': 'Hoa Vo',
      'email': 'hoa.vo@sunshine.edu',
      'class_name': '12C3',
      'gpa': 9.4,
    },
  ];

  Future<List<Map<String, Object?>>> fetchStudents() async => _students;

  Future<Map<String, Object?>> fetchStudent(String id) async =>
      _students.firstWhere((student) => student['id'] == id);
}
