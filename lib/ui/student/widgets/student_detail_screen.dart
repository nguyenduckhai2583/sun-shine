import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/student_detail_viewmodel.dart';

/// Takes a plain [String], never a `GoRouterState`, so it can be built
/// anywhere — including straight from a deep link to /students/s-3.
class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    // This page is pushed on the ROOT navigator, so it is a sibling of the
    // home shell, not a child. It resolves StudentRepository anyway, because
    // the repository lives in the root scope ABOVE MaterialApp.router —
    // which is exactly what makes the page independently addressable.
    return ChangeNotifierProvider(
      create: (context) => StudentDetailViewModel(
        studentId: studentId,
        repository: context.read(),
      )..load(),
      child: const _StudentDetailView(),
    );
  }
}

class _StudentDetailView extends StatelessWidget {
  const _StudentDetailView();

  @override
  Widget build(BuildContext context) {
    final student = context.watch<StudentDetailViewModel>().student;

    return Scaffold(
      appBar: AppBar(title: Text(student?.name ?? 'Student')),
      body: student == null
          ? const SizedBox.shrink()
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Student id'),
                  subtitle: Text(student.id),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(student.email),
                ),
                ListTile(
                  leading: const Icon(Icons.groups_outlined),
                  title: const Text('Class'),
                  subtitle: Text(student.className),
                ),
                ListTile(
                  leading: const Icon(Icons.grade_outlined),
                  title: const Text('GPA'),
                  subtitle: Text(student.gpa.toStringAsFixed(1)),
                ),
              ],
            ),
    );
  }
}
