import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/teacher_repository.dart';
import '../data/repositories/teacher_repository_impl.dart';
import '../data/services/api/teacher_api_client.dart';
import '../ui/auth/widgets/sign_in_screen.dart';
import '../ui/student/widgets/student_detail_screen.dart';
import '../ui/student/widgets/students_screen.dart';
import '../ui/teacher/widgets/teacher_detail_screen.dart';
import '../ui/teacher/widgets/teachers_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// ```
/// /sign-in
/// /students                      <- home
///   \- :studentId                <- StudentDetailScreen
/// ShellRoute                     <- teacher module scope
///   \- /teachers                 <- TeachersScreen
///        \- :teacherId           <- TeacherDetailScreen
/// ```
GoRouter createRouter({
  required AuthRepository authRepository,
  String initialLocation = Routes.signIn,
  bool debugLogDiagnostics = false,
}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: initialLocation,
  debugLogDiagnostics: debugLogDiagnostics,

  // No `refreshListenable`. AuthScope re-keys on every session change, which
  // remounts this router; `redirect` then decides where that lands.
  redirect: (context, state) {
    final goingToSignIn = state.matchedLocation == Routes.signIn;
    if (!authRepository.isSignedIn) return goingToSignIn ? null : Routes.signIn;
    return goingToSignIn ? Routes.students : null;
  },

  routes: [
    GoRoute(
      path: Routes.signIn,
      pageBuilder: (context, state) => _page(state, const SignInScreen()),
    ),

    GoRoute(
      path: Routes.students,
      pageBuilder: (context, state) => _page(state, const StudentsScreen()),
      routes: [
        GoRoute(
          path: Routes.studentDetailRelative,
          pageBuilder: (context, state) => _page(
            state,
            StudentDetailScreen(
              studentId: state.pathParameters['studentId']!,
            ),
          ),
        ),
      ],
    ),

    // The teacher module scope.
    //
    // Nesting routes is NOT enough to share a provider: every GoRoute makes
    // its own Page, and pages are siblings in a Navigator stack, not parent
    // and child. `context.read` walks up the ELEMENT tree, so a detail page
    // could never reach a provider mounted by the list page.
    //
    // ShellRoute is the one construct that makes a widget a real ancestor of
    // several routes, because its builder receives the nested Navigator as
    // `child`. So TeacherRepository is created when /teachers opens, shared
    // with /teachers/:teacherId, and disposed by the framework when the
    // module is popped.
    ShellRoute(
      builder: (context, state, child) => MultiProvider(
        providers: [
          Provider<TeacherApiClient>(
            create: (context) => FakeTeacherApiClient(),
          ),
          Provider<TeacherRepository>(
            create: (context) => TeacherRepositoryImpl(apiClient: context.read()),
            dispose: (context, repository) =>
                debugPrint('[teachers] repository disposed'),
          ),
        ],
        child: child,
      ),
      routes: [
        GoRoute(
          path: Routes.teachers,
          pageBuilder: (context, state) => _page(state, const TeachersScreen()),
          routes: [
            GoRoute(
              path: Routes.teacherDetailRelative,
              pageBuilder: (context, state) => _page(
                state,
                TeacherDetailScreen(
                  teacherId: state.pathParameters['teacherId']!,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Explicit pages, so a push animates. With `builder:`, go_router 18 decides
/// the page type by sniffing for a `material_ui` `MaterialApp`; this app uses
/// `flutter/material`, that check fails, and every push would silently fall
/// back to a no-transition page.
Page<void> _page(GoRouterState state, Widget child) =>
    MaterialPage<void>(key: state.pageKey, name: state.name, child: child);
