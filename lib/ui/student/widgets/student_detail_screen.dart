import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/student_detail_bloc.dart';

/// Takes a plain [String], never a `GoRouterState`, so it can be built
/// anywhere — including straight from a deep link to /students/s-3.
class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    // Pushed on the ROOT navigator, so this page is a sibling of the list,
    // not a child. It resolves StudentRepository anyway, because the session
    // scope sits ABOVE MaterialApp.router.
    return BlocProvider(
      create: (context) =>
          StudentDetailBloc(studentId: studentId, repository: context.read()),
      child: const _StudentDetailView(),
    );
  }
}

class _StudentDetailView extends StatelessWidget {
  const _StudentDetailView();

  @override
  Widget build(BuildContext context) {
    final student = context.watch<StudentDetailBloc>().state.student;

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
