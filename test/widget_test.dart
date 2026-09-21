import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sun_shine/config/build_config.dart';
import 'package:sun_shine/data/repositories/auth_repository.dart';
import 'package:sun_shine/data/repositories/student_repository.dart';
import 'package:sun_shine/data/repositories/teacher_repository.dart';
import 'package:sun_shine/main.dart';
import 'package:sun_shine/ui/student/widgets/students_screen.dart';
import 'package:sun_shine/ui/teacher/widgets/teacher_detail_screen.dart';
import 'package:sun_shine/ui/teacher/widgets/teachers_screen.dart';

void main() {
  setUpAll(BuildConfig().setupEnvironment);

  Future<void> signIn(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
  }

  Future<void> openTeachers(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Teachers'));
    await tester.pumpAndSettle();
  }

  T readFrom<T>(WidgetTester tester, Type screen) =>
      tester.element(find.byType(screen)).read<T>();

  testWidgets('sign in, students list, student detail', (tester) async {
    await tester.pumpWidget(const SunShineApp());
    await tester.pumpAndSettle();
    expect(find.text('Sun Shine'), findsOneWidget);

    await signIn(tester);
    expect(find.text('Students'), findsOneWidget);
    expect(find.text('An Nguyen'), findsOneWidget);

    await tester.tap(find.text('An Nguyen'));
    await tester.pumpAndSettle();
    expect(find.text('an.nguyen@sunshine.edu'), findsOneWidget);
  });

  testWidgets('the teacher module opens, and its detail shares the scope', (
    tester,
  ) async {
    await tester.pumpWidget(const SunShineApp());
    await tester.pumpAndSettle();
    await signIn(tester);

    // Before the module opens, TeacherRepository does not exist anywhere.
    expect(
      () => readFrom<TeacherRepository>(tester, StudentsScreen),
      throwsA(isA<ProviderNotFoundException>()),
      reason: 'the teacher repository is not in the session scope',
    );

    await openTeachers(tester);
    expect(find.text('Mai Hoang'), findsOneWidget);
    final fromList = readFrom<TeacherRepository>(tester, TeachersScreen);

    await tester.tap(find.text('Mai Hoang'));
    await tester.pumpAndSettle();
    expect(find.text('Mathematics'), findsOneWidget);

    expect(
      identical(
        fromList,
        readFrom<TeacherRepository>(tester, TeacherDetailScreen),
      ),
      isTrue,
      reason: 'list and detail must share the one module-scoped repository',
    );
  });

  testWidgets('popping back to students disposes the teacher module', (
    tester,
  ) async {
    await tester.pumpWidget(const SunShineApp());
    await tester.pumpAndSettle();
    await signIn(tester);

    await openTeachers(tester);
    final first = readFrom<TeacherRepository>(tester, TeachersScreen);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Students'), findsOneWidget);

    // Gone from the tree entirely.
    expect(
      () => readFrom<TeacherRepository>(tester, StudentsScreen),
      throwsA(isA<ProviderNotFoundException>()),
    );

    // Re-opening builds a new one, so the old instance was really dropped.
    await openTeachers(tester);
    expect(
      identical(first, readFrom<TeacherRepository>(tester, TeachersScreen)),
      isFalse,
    );
  });

  testWidgets('the student cache lives and dies with the session', (
    tester,
  ) async {
    await tester.pumpWidget(const SunShineApp());
    await tester.pumpAndSettle();

    debugPrint('\n-- session 1: sign in, list loads');
    await signIn(tester);

    debugPrint('-- session 1: open a detail, the list already has it');
    await tester.tap(find.text('An Nguyen'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    debugPrint('-- sign out: the session scope is disposed, cache with it');
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    debugPrint('-- session 2: a brand new repository, so the list refetches');
    await signIn(tester);
    debugPrint('');
  });

  testWidgets('session scope is torn down and rebuilt across a sign-out', (
    tester,
  ) async {
    await tester.pumpWidget(const SunShineApp());
    await tester.pumpAndSettle();

    await signIn(tester);
    final firstSession = readFrom<StudentRepository>(tester, StudentsScreen);
    final auth = readFrom<AuthRepository>(tester, StudentsScreen);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    expect(find.text('Sun Shine'), findsOneWidget);

    await signIn(tester);

    expect(
      identical(
        firstSession,
        readFrom<StudentRepository>(tester, StudentsScreen),
      ),
      isFalse,
      reason: 'the second user must not inherit the first session\'s cache',
    );
    expect(
      identical(auth, readFrom<AuthRepository>(tester, StudentsScreen)),
      isTrue,
      reason: 'AuthRepository lives in the app scope and outlives sessions',
    );
  });
}
