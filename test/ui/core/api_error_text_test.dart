import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';
import 'package:sun_shine/l10n/app_localizations_en.dart';

void main() {
  group('ApiErrorText.localizedMessage', () {
    final l10n = AppLocalizationsEn();

    test('translates every transport failure', () {
      const cases = {
        ApiErrorEnum.noInternet: 'No internet connection',
        ApiErrorEnum.timeout:
            'Request timed out. Please check your connection.',
        ApiErrorEnum.cancelled: 'The request was cancelled',
        ApiErrorEnum.badCertificate: 'Incorrect certificate as configured',
        ApiErrorEnum.badFormat: 'Bad response format',
        ApiErrorEnum.unknown: 'Something went wrong',
      };

      for (final entry in cases.entries) {
        expect(
          ApiException(error: entry.key).localizedMessage(l10n),
          entry.value,
          reason: 'no translation for ${entry.key.name}',
        );
      }
    });

    test('keeps the server its own wording', () {
      const exception = ApiException(
        error: ApiErrorEnum.server,
        serverMessage: 'Email already taken',
        statusCode: 400,
      );

      expect(exception.localizedMessage(l10n), 'Email already taken');
    });

    test('falls back when the server gave no reason', () {
      const exception = ApiException(
        error: ApiErrorEnum.server,
        statusCode: 500,
      );

      expect(exception.localizedMessage(l10n), 'Something went wrong');
    });

    test('covers every value of the enum', () {
      for (final kind in ApiErrorEnum.values) {
        expect(
          ApiException(error: kind).localizedMessage(l10n),
          isNotEmpty,
          reason: '${kind.name} produced no message',
        );
      }
    });
  });
}
