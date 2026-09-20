// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Session {

 String get userId; String get token; String? get refreshToken; int? get expireAt; bool get isTmpToken; String? get workspaceId; User? get user;/// The MD5 of the salted password, derived at sign-in.
///
/// Combined with the user's passcode it produces the key that unlocks
/// [encryptedPrivateKey]; the plaintext password is never kept.
 String? get md5Password;/// The user's E2E private key as the server holds it — wrapped with a key
/// derived from their credentials, so the server cannot read it.
 String? get encryptedPrivateKey;/// The same private key re-wrapped with this device's key, so unlocking it
/// again does not require the password.
 String? get localEncryptedPrivateKey;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Session;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expireAt, _this.expireAt) || other.expireAt == _this.expireAt)&&(identical(other.isTmpToken, _this.isTmpToken) || other.isTmpToken == _this.isTmpToken)&&(identical(other.workspaceId, _this.workspaceId) || other.workspaceId == _this.workspaceId)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.md5Password, _this.md5Password) || other.md5Password == _this.md5Password)&&(identical(other.encryptedPrivateKey, _this.encryptedPrivateKey) || other.encryptedPrivateKey == _this.encryptedPrivateKey)&&(identical(other.localEncryptedPrivateKey, _this.localEncryptedPrivateKey) || other.localEncryptedPrivateKey == _this.localEncryptedPrivateKey));
}


@override
int get hashCode {
  final _this = this as Session;
  return Object.hash(runtimeType,_this.userId,_this.token,_this.refreshToken,_this.expireAt,_this.isTmpToken,_this.workspaceId,_this.user,_this.md5Password,_this.encryptedPrivateKey,_this.localEncryptedPrivateKey);
}

@override
String toString() {
  final _this = this as Session;
  return 'Session(userId: ${_this.userId}, token: ${_this.token}, refreshToken: ${_this.refreshToken}, expireAt: ${_this.expireAt}, isTmpToken: ${_this.isTmpToken}, workspaceId: ${_this.workspaceId}, user: ${_this.user}, md5Password: ${_this.md5Password}, encryptedPrivateKey: ${_this.encryptedPrivateKey}, localEncryptedPrivateKey: ${_this.localEncryptedPrivateKey})';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String userId, String token, String? refreshToken, int? expireAt, bool isTmpToken, String? workspaceId, User? user, String? md5Password, String? encryptedPrivateKey, String? localEncryptedPrivateKey
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? token = null,Object? refreshToken = freezed,Object? expireAt = freezed,Object? isTmpToken = null,Object? workspaceId = freezed,Object? user = freezed,Object? md5Password = freezed,Object? encryptedPrivateKey = freezed,Object? localEncryptedPrivateKey = freezed,}) {
  return _then(Session(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as int?,isTmpToken: null == isTmpToken ? _self.isTmpToken : isTmpToken // ignore: cast_nullable_to_non_nullable
as bool,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,md5Password: freezed == md5Password ? _self.md5Password : md5Password // ignore: cast_nullable_to_non_nullable
as String?,encryptedPrivateKey: freezed == encryptedPrivateKey ? _self.encryptedPrivateKey : encryptedPrivateKey // ignore: cast_nullable_to_non_nullable
as String?,localEncryptedPrivateKey: freezed == localEncryptedPrivateKey ? _self.localEncryptedPrivateKey : localEncryptedPrivateKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String token,  String? refreshToken,  int? expireAt,  bool isTmpToken,  String? workspaceId,  User? user,  String? md5Password,  String? encryptedPrivateKey,  String? localEncryptedPrivateKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.userId,_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.workspaceId,_that.user,_that.md5Password,_that.encryptedPrivateKey,_that.localEncryptedPrivateKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String token,  String? refreshToken,  int? expireAt,  bool isTmpToken,  String? workspaceId,  User? user,  String? md5Password,  String? encryptedPrivateKey,  String? localEncryptedPrivateKey)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.userId,_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.workspaceId,_that.user,_that.md5Password,_that.encryptedPrivateKey,_that.localEncryptedPrivateKey);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String token,  String? refreshToken,  int? expireAt,  bool isTmpToken,  String? workspaceId,  User? user,  String? md5Password,  String? encryptedPrivateKey,  String? localEncryptedPrivateKey)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.userId,_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.workspaceId,_that.user,_that.md5Password,_that.encryptedPrivateKey,_that.localEncryptedPrivateKey);case _:
  return null;

}
}

}

/// @nodoc


class _Session extends Session {
  const _Session({required this.userId, required this.token, this.refreshToken, this.expireAt, this.isTmpToken = false, this.workspaceId, this.user, this.md5Password, this.encryptedPrivateKey, this.localEncryptedPrivateKey}): super._();
  

@override final  String userId;
@override final  String token;
@override final  String? refreshToken;
@override final  int? expireAt;
@override@JsonKey() final  bool isTmpToken;
@override final  String? workspaceId;
@override final  User? user;
/// The MD5 of the salted password, derived at sign-in.
///
/// Combined with the user's passcode it produces the key that unlocks
/// [encryptedPrivateKey]; the plaintext password is never kept.
@override final  String? md5Password;
/// The user's E2E private key as the server holds it — wrapped with a key
/// derived from their credentials, so the server cannot read it.
@override final  String? encryptedPrivateKey;
/// The same private key re-wrapped with this device's key, so unlocking it
/// again does not require the password.
@override final  String? localEncryptedPrivateKey;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt)&&(identical(other.isTmpToken, isTmpToken) || other.isTmpToken == isTmpToken)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.user, user) || other.user == user)&&(identical(other.md5Password, md5Password) || other.md5Password == md5Password)&&(identical(other.encryptedPrivateKey, encryptedPrivateKey) || other.encryptedPrivateKey == encryptedPrivateKey)&&(identical(other.localEncryptedPrivateKey, localEncryptedPrivateKey) || other.localEncryptedPrivateKey == localEncryptedPrivateKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,token,refreshToken,expireAt,isTmpToken,workspaceId,user,md5Password,encryptedPrivateKey,localEncryptedPrivateKey);
}

@override
String toString() {
    return 'Session(userId: $userId, token: $token, refreshToken: $refreshToken, expireAt: $expireAt, isTmpToken: $isTmpToken, workspaceId: $workspaceId, user: $user, md5Password: $md5Password, encryptedPrivateKey: $encryptedPrivateKey, localEncryptedPrivateKey: $localEncryptedPrivateKey)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String userId, String token, String? refreshToken, int? expireAt, bool isTmpToken, String? workspaceId, User? user, String? md5Password, String? encryptedPrivateKey, String? localEncryptedPrivateKey
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? token = null,Object? refreshToken = freezed,Object? expireAt = freezed,Object? isTmpToken = null,Object? workspaceId = freezed,Object? user = freezed,Object? md5Password = freezed,Object? encryptedPrivateKey = freezed,Object? localEncryptedPrivateKey = freezed,}) {
  return _then(_Session(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as int?,isTmpToken: null == isTmpToken ? _self.isTmpToken : isTmpToken // ignore: cast_nullable_to_non_nullable
as bool,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,md5Password: freezed == md5Password ? _self.md5Password : md5Password // ignore: cast_nullable_to_non_nullable
as String?,encryptedPrivateKey: freezed == encryptedPrivateKey ? _self.encryptedPrivateKey : encryptedPrivateKey // ignore: cast_nullable_to_non_nullable
as String?,localEncryptedPrivateKey: freezed == localEncryptedPrivateKey ? _self.localEncryptedPrivateKey : localEncryptedPrivateKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
