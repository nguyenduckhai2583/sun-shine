import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// A tiny stand-in for AuthRepository, with two pieces of state:
/// `userId` (what AuthScope keys on) and `name` (what it does NOT care about).
class Session extends ChangeNotifier {
  String? userId;
  String name = '';

  void signIn(String id, String userName) {
    userId = id;
    name = userName;
    debugPrint('\n== signIn("$id") -> notifyListeners()');
    notifyListeners();
  }

  void rename(String userName) {
    name = userName;
    debugPrint(
      '\n== rename("$userName") -> notifyListeners()   [userId unchanged]',
    );
    notifyListeners();
  }

  void signOut() {
    userId = null;
    name = '';
    debugPrint('\n== signOut() -> notifyListeners()');
    notifyListeners();
  }
}

/// Uses select: subscribes, but only rebuilds when `userId` changes.
class SelectWidget extends StatelessWidget {
  const SelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select<Session, String?>((session) {
      debugPrint('   [select] selector ran -> ${session.userId}');
      return session.userId;
    });
    debugPrint('   [select] >>> BUILD, userId=$userId');
    return Text('select:$userId');
  }
}

/// Uses watch: subscribes, and rebuilds on every notification.
class WatchWidget extends StatelessWidget {
  const WatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<Session>();
    debugPrint('   [watch ] >>> BUILD, userId=${session.userId}');
    return Text('watch:${session.userId}');
  }
}

void main() {
  testWidgets('select vs watch, step by step', (tester) async {
    final session = Session();
    addTearDown(session.dispose);

    debugPrint('\n== first frame');
    await tester.pumpWidget(
      ChangeNotifierProvider<Session>.value(
        value: session,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Column(children: [SelectWidget(), WatchWidget()]),
        ),
      ),
    );

    session.signIn('u-1', 'Khai');
    await tester.pump();

    session.rename('Khai Nguyen');
    await tester.pump();

    session.signOut();
    await tester.pump();

    debugPrint('');
  });
}
