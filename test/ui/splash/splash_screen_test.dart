import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../testing/fakes/fake_session_repository.dart';

void main() {
  late FakeSessionRepository repository;
  late SessionManager manager;

  setUp(() {
    repository = FakeSessionRepository();
    manager = SessionManager(sessionRepository: repository);
    addTearDown(manager.dispose);
    addTearDown(repository.dispose);
  });

  Future<void> pumpSplash(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider.value(
        value: manager,
        child: const MaterialApp(home: SplashScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('boots the session on its way past', (tester) async {
    await pumpSplash(tester);

    expect(repository.restoreCount, 1);
    expect(manager.isRestored, isTrue);
  });

  testWidgets('hands back whatever was stored', (tester) async {
    repository.stored = [fakeStoredSession];

    await pumpSplash(tester);

    expect(manager.currentSession?.userId, 'u1');
  });

  testWidgets('a store that throws still lets the app move on', (tester) async {
    repository.restoreError = StateError('corrupt row');

    await pumpSplash(tester);

    expect(manager.isRestored, isTrue);
  });
}

const fakeStoredSession = Session(
  userId: 'u1',
  token: 't1',
  workspaceId: 'w1',
  user: User(id: 'u1', email: 'khai@sunshine.com'),
);
