import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';
import '../../../routing/routes.dart';
import '../view_models/students_viewmodel.dart';

/// Home. Mounts its own view model scope, reading StudentRepository from the
/// session scope above.
class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StudentsViewModel(repository: context.read())..load(),
      child: const _StudentsView(),
    );
  }
}

class _StudentsView extends StatelessWidget {
  const _StudentsView();

  @override
  Widget build(BuildContext context) {
    final students = context.watch<StudentsViewModel>().students;
    // AuthScope puts the session's User in the scope as a plain value, so
    // the app bar does not need to watch the repository at all.
    final name = context.watch<User?>()?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          Center(child: Text(name)),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthRepository>().signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        itemCount: students.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: CircleAvatar(child: Text(student.name.characters.first)),
            title: Text(student.name),
            subtitle: Text('Class ${student.className}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.studentDetail(student.id)),
          );
        },
      ),
      // Opens the teacher module. TeacherRepository does not exist yet at
      // this point — pushing this route is what creates it.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.teachers),
        icon: const Icon(Icons.co_present),
        label: const Text('Teachers'),
      ),
    );
  }
}
