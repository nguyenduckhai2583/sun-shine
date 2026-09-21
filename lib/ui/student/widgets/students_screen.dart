import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/students_bloc.dart';

/// Home. Mounts its own bloc, reading StudentRepository from the session
/// scope above.
class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentsBloc(repository: context.read()),
      child: const _StudentsView(),
    );
  }
}

class _StudentsView extends StatelessWidget {
  const _StudentsView();

  @override
  Widget build(BuildContext context) {
    final students = context.watch<StudentsBloc>().state.visibleStudents;
    final name = context.select((AuthBloc bloc) => bloc.state.user?.name ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          Center(child: Text(name)),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignedOut()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              // Every keystroke fires an event; the bloc's transformer is
              // what waits 300ms and keeps only the last one.
              onChanged: (query) => context.read<StudentsBloc>().add(
                StudentsSearchChanged(query),
              ),
              decoration: const InputDecoration(
                hintText: 'Search name or class',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(student.name.characters.first),
                  ),
                  title: Text(student.name),
                  subtitle: Text('Class ${student.className}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.studentDetail(student.id)),
                );
              },
            ),
          ),
        ],
      ),
      // Opens the teacher module. TeacherRepository does not exist yet —
      // pushing this route is what creates it.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.teachers),
        icon: const Icon(Icons.co_present),
        label: const Text('Teachers'),
      ),
    );
  }
}
