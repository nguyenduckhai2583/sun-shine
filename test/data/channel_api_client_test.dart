import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ChannelApiClient', () {
    test('returns a known channel', () async {
      final result = await ChannelApiClient().getChannel('general');

      expect(result, isA<Ok<ChannelApiModel>>());
      expect((result as Ok<ChannelApiModel>).value.memberCount, 128);
    });

    test('errors for an unknown channel', () async {
      final result = await ChannelApiClient().getChannel('does_not_exist');

      expect(result, isA<Error<ChannelApiModel>>());
      expect(
        (result as Error<ChannelApiModel>).error,
        isA<ChannelNotFoundException>(),
      );
    });
  });
}
