import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String token,
    String? refreshToken,
    int? expireAt,
    @Default(false) bool isTmpToken,
    String? workspaceId,
    User? user,

    String? md5Password,

    String? encryptedPrivateKey,

    String? localEncryptedPrivateKey,
  }) = _Session;

  const Session._();

  bool get isFullyAuthenticated => !isTmpToken;

  bool get needsWorkspace => workspaceId == null;
}
