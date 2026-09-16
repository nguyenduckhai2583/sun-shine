import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('Command0', () {
    test('exposes running while in flight, then completed', () async {
      final completer = Completer<Result<int>>();
      final command = Command0<int>(() => completer.future);
      final future = command.execute();
      expect(command.running, isTrue);
      expect(command.completed, isFalse);
      completer.complete(const Result.ok(1));
      await future;
      expect(command.running, isFalse);
      expect(command.completed, isTrue);
      expect(command.error, isFalse);
    });
    test('ignores a second execute while already running', () async {
      var calls = 0;
      final completer = Completer<Result<int>>();
      final command = Command0<int>(() {
        calls++;
        return completer.future;
      });
      final first = command.execute();
      await command.execute();
      completer.complete(const Result.ok(1));
      await first;
      expect(calls, 1);
    });
    test('records a failure without throwing', () async {
      final command = Command0<int>(
        () async => Result.error(Exception('boom')),
      );
      await command.execute();
      expect(command.error, isTrue);
      expect(command.completed, isFalse);
    });
    test('clearResult resets the outcome and notifies', () async {
      final command = Command0<int>(() async => const Result.ok(1));
      await command.execute();
      var notifications = 0;
      command.addListener(() => notifications++);
      command.clearResult();
      expect(command.result, isNull);
      expect(command.completed, isFalse);
      expect(notifications, 1);
    });
  });

  group('Command1', () {
    test('passes its argument through to the action', () async {
      int? received;
      final command = Command1<int, int>((value) async {
        received = value;
        return Result.ok(value * 2);
      });
      await command.execute(21);
      expect(received, 21);
      expect((command.result! as Ok<int>).value, 42);
    });
  });
}
