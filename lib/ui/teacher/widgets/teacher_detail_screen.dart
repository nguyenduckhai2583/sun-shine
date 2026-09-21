import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/teacher_detail_viewmodel.dart';

class TeacherDetailScreen extends StatelessWidget {
  const TeacherDetailScreen({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TeacherDetailViewModel(
        teacherId: teacherId,
        repository: context.read(),
      )..load(),
      child: const _TeacherDetailView(),
    );
  }
}

class _TeacherDetailView extends StatelessWidget {
  const _TeacherDetailView();

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherDetailViewModel>().teacher;

    return Scaffold(
      appBar: AppBar(title: Text(teacher?.name ?? 'Teacher')),
      body: teacher == null
          ? const SizedBox.shrink()
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Teacher id'),
                  subtitle: Text(teacher.id),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(teacher.email),
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: const Text('Subject'),
                  subtitle: Text(teacher.subject),
                ),
                ListTile(
                  leading: const Icon(Icons.timeline_outlined),
                  title: const Text('Experience'),
                  subtitle: Text('${teacher.yearsOfExperience} years'),
                ),
              ],
            ),
    );
  }
}
