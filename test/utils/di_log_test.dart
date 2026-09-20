import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../testing/pump_app.dart';

void main() {
  late List<String> logs;

  setUp(() {
    logs = [];
    Di.observer = const DiLog();
    DiLog.enabled = true;
    DiLog.output = logs.add;
  });

  tearDown(() {
    Di.observer = const DiObserver.silent();
    DiLog.output = null;
    DiLog.enabled = kDebugMode;
  });

  List<String> eventsFor(String type) =>
      logs.where((l) => l.startsWith('[di] $type ')).toList();

  // '[di] ChannelLocalService created' -> 'ChannelLocalService'
  String typeOf(String line) =>
      line.replaceFirst('[di] ', '').split(' ').first;

  testWidgets('every layer logs on creation', (tester) async {
    await pumpApp(tester);

    // AuthApiClient is absent on purpose: the harness fakes it, and a fake
    // is not a layer this observer is meant to see.
    for (final type in [
      'AuthLocalService',
      'AuthRepositoryImpl',
      'SessionRepositoryImpl',
      'ChannelApiClient',
      'ChannelLocalService',
      'ChannelRepositoryImpl',
      'WorkspaceApiClient',
      'WorkspaceRepositoryImpl',
      'HomeViewModel',
      'ChannelsViewModel',
    ]) {
      expect(eventsFor(type), hasLength(1), reason: '$type was not logged');
    }

    expect(logs.first, matches(RegExp(r'^\[di\] \w+ created$')));
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
    expect(eventsFor('PlanixProjectsViewModel').single, endsWith(' created'));

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
      eventsFor('PlanixProjectsViewModel'),
      ['[di] PlanixProjectsViewModel created', '[di] PlanixProjectsViewModel deleted'],
      reason: 'created on the way in, deleted on the way out',
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
        .where((l) => l.endsWith(' deleted'))
        .map(typeOf)
        .toList();

    expect(
      disposed,
      containsAll(['ChannelLocalService', 'HomeViewModel', 'ChannelsViewModel']),
      reason: 'ViewModels and resource-owning services release with the scope',
    );
    expect(
      disposed,
      isNot(contains('AuthLocalService')),
      reason: 'auth outlives the session scope',
    );
  });

  testWidgets('disabled means silent', (tester) async {
    DiLog.enabled = false;
    await pumpApp(tester);

    expect(logs, isEmpty);
  });

  test('Di.observed reports creation and hands the instance back', () {
    final instance = StringBuffer('x');

    final returned = Di.observed(instance);

    expect(
      identical(returned, instance),
      isTrue,
      reason: 'it wraps a registration, so it must be transparent',
    );
    expect(logs, ['[di] StringBuffer created']);
  });
}
