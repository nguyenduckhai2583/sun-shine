import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routing/routes.dart';
import '../view_models/teachers_viewmodel.dart';

/// The entry page of the teacher module. TeacherRepository comes from the
/// `ShellRoute` scope in `routing/router.dart`, not from the session scope.
class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TeachersViewModel(repository: context.read())..load(),
      child: const _TeachersView(),
    );
  }
}

class _TeachersView extends StatelessWidget {
  const _TeachersView();

  @override
  Widget build(BuildContext context) {
    final teachers = context.watch<TeachersViewModel>().teachers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
        // ShellRoute always builds a nested Navigator, and /teachers is its
        // first route, so canPop is false here and no back button is implied.
        // `context.pop()` pops the first navigator that can — the root one.
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView.separated(
        itemCount: teachers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return ListTile(
            leading: CircleAvatar(child: Text(teacher.name.characters.first)),
            title: Text(teacher.name),
            subtitle: Text(teacher.subject),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.teacherDetail(teacher.id)),
          );
        },
      ),
    );
  }
}
