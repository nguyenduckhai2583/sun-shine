import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../testing/pump_app.dart';

void main() {
  late List<String> logs;

  setUp(() {
    logs = [];
    DiLog.enabled = true;
    DiLog.output = logs.add;
  });

  tearDown(() {
    DiLog.output = null;
    DiLog.enabled = kDebugMode;
  });

  List<String> eventsFor(String type) =>
      logs.where((l) => l.contains(' $type#')).toList();

  testWidgets('every layer logs on creation', (tester) async {
    await pumpApp(tester);

    for (final type in [
      'AuthApiClient',
      'AuthLocalService',
      'AuthRepositoryRemote',
      'ChannelApiClient',
      'ChannelLocalService',
      'ChannelRepositoryRemote',
      'WorkspaceApiClient',
      'WorkspaceRepositoryRemote',
      'HomeViewModel',
      'ChannelsViewModel',
    ]) {
      expect(eventsFor(type), hasLength(1), reason: '$type was not logged');
    }

    expect(logs.first, matches(RegExp(r'^\[di\] \+ \w+#[0-9a-f]+$')));
  });

  testWidgets('a module logs create then dispose across its lifetime', (
    tester,
  ) async {
    await pumpApp(tester);
    logs.clear();

    await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Planix'));
    await tester.pumpAndSettle();

    expect(eventsFor('PlanixProjectsViewModel'), hasLength(1));
    expect(eventsFor('PlanixProjectsViewModel').single, startsWith('[di] + '));

    await tester.pageBack();
    await tester.pumpAndSettle();

    final events = eventsFor('PlanixProjectsViewModel');
    expect(events, hasLength(2));
    expect(events.last, startsWith('[di] - '));
    expect(
      events.first.split('#').last,
      events.last.split('#').last,
      reason: 'the same instance was created then disposed',
    );
  });

  testWidgets('sign-out logs disposal of the whole session scope', (
    tester,
  ) async {
    await pumpApp(tester);
    logs.clear();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
    await tester.pumpAndSettle();

    final disposed = logs
        .where((l) => l.startsWith('[di] - '))
        .map((l) => l.split('#').first.replaceFirst('[di] - ', ''))
        .toList();

    expect(
      disposed,
      containsAll([
        'ChannelApiClient',
        'ChannelLocalService',
        'ChannelRepositoryRemote',
        'HomeViewModel',
        'ChannelsViewModel',
      ]),
    );
    expect(
      disposed,
      isNot(contains('AuthRepositoryRemote')),
      reason: 'auth outlives the session scope',
    );
  });

  testWidgets('disabled means silent', (tester) async {
    DiLog.enabled = false;
    await pumpApp(tester);

    expect(logs, isEmpty);
  });
}
