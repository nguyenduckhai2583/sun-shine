import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

part 'session_entity.g.dart';

@Collection()
class SessionEntity {
  SessionEntity({
    required this.accountUserId,
    required this.isActive,
    required this.token,
    this.refreshToken,
    this.expireAt,
    this.isTmpToken = false,
    this.workspaceId,
    this.md5Password,
    this.encryptedPrivateKey,
    this.localEncryptedPrivateKey,
    this.userEmail,
    this.userFullName,
    this.userAvatar,
  });

  factory SessionEntity.fromDomain(Session session, {required bool isActive}) {
    return SessionEntity(
      accountUserId: session.userId,
      isActive: isActive,
      token: session.token,
      refreshToken: session.refreshToken,
      expireAt: session.expireAt,
      isTmpToken: session.isTmpToken,
      workspaceId: session.workspaceId,
      md5Password: session.md5Password,
      encryptedPrivateKey: session.encryptedPrivateKey,
      localEncryptedPrivateKey: session.localEncryptedPrivateKey,
      userEmail: session.user?.email,
      userFullName: session.user?.fullName,
      userAvatar: session.user?.avatar,
    );
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String accountUserId;

  bool isActive;

  String token;
  String? refreshToken;
  int? expireAt;
  bool isTmpToken;
  String? workspaceId;

  String? md5Password;
  String? encryptedPrivateKey;
  String? localEncryptedPrivateKey;

  String? userEmail;
  String? userFullName;
  String? userAvatar;

  Session toDomain() {
    return Session(
      userId: accountUserId,
      token: token,
      refreshToken: refreshToken,
      expireAt: expireAt,
      isTmpToken: isTmpToken,
      workspaceId: workspaceId,
      md5Password: md5Password,
      encryptedPrivateKey: encryptedPrivateKey,
      localEncryptedPrivateKey: localEncryptedPrivateKey,
      user: userEmail == null
          ? null
          : User(
              id: accountUserId,
              email: userEmail!,
              fullName: userFullName,
              avatar: userAvatar,
            ),
    );
  }
}
