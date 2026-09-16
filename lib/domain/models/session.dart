import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String email,
    required String accessToken,
  }) = _Session;
}
