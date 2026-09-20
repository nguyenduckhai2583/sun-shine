// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionApiModel {

 String get token; String? get refreshToken; int? get expireAt; bool? get isTmpToken; UserApiModel? get user;
/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionApiModelCopyWith<SessionApiModel> get copyWith => _$SessionApiModelCopyWithImpl<SessionApiModel>(this as SessionApiModel, _$identity);

  /// Serializes this SessionApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionApiModel&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expireAt, _this.expireAt) || other.expireAt == _this.expireAt)&&(identical(other.isTmpToken, _this.isTmpToken) || other.isTmpToken == _this.isTmpToken)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionApiModel;
  return Object.hash(runtimeType,_this.token,_this.refreshToken,_this.expireAt,_this.isTmpToken,_this.user);
}

@override
String toString() {
  final _this = this as SessionApiModel;
  return 'SessionApiModel(token: ${_this.token}, refreshToken: ${_this.refreshToken}, expireAt: ${_this.expireAt}, isTmpToken: ${_this.isTmpToken}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $SessionApiModelCopyWith<$Res>  {
  factory $SessionApiModelCopyWith(SessionApiModel value, $Res Function(SessionApiModel) _then) = _$SessionApiModelCopyWithImpl;
@useResult
$Res call({
 String token, String? refreshToken, int? expireAt, bool? isTmpToken, UserApiModel? user
});


$UserApiModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$SessionApiModelCopyWithImpl<$Res>
    implements $SessionApiModelCopyWith<$Res> {
  _$SessionApiModelCopyWithImpl(this._self, this._then);

  final SessionApiModel _self;
  final $Res Function(SessionApiModel) _then;

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? refreshToken = freezed,Object? expireAt = freezed,Object? isTmpToken = freezed,Object? user = freezed,}) {
  return _then(SessionApiModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as int?,isTmpToken: freezed == isTmpToken ? _self.isTmpToken : isTmpToken // ignore: cast_nullable_to_non_nullable
as bool?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserApiModel?,
  ));
}
/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserApiModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserApiModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionApiModel].
extension SessionApiModelPatterns on SessionApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionApiModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String? refreshToken,  int? expireAt,  bool? isTmpToken,  UserApiModel? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
return $default(_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String? refreshToken,  int? expireAt,  bool? isTmpToken,  UserApiModel? user)  $default,) {final _that = this;
switch (_that) {
case _SessionApiModel():
return $default(_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String? refreshToken,  int? expireAt,  bool? isTmpToken,  UserApiModel? user)?  $default,) {final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
return $default(_that.token,_that.refreshToken,_that.expireAt,_that.isTmpToken,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionApiModel implements SessionApiModel {
  const _SessionApiModel({required this.token, this.refreshToken, this.expireAt, this.isTmpToken, this.user});
  factory _SessionApiModel.fromJson(Map<String, dynamic> json) => _$SessionApiModelFromJson(json);

@override final  String token;
@override final  String? refreshToken;
@override final  int? expireAt;
@override final  bool? isTmpToken;
@override final  UserApiModel? user;

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionApiModelCopyWith<_SessionApiModel> get copyWith => __$SessionApiModelCopyWithImpl<_SessionApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionApiModel&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt)&&(identical(other.isTmpToken, isTmpToken) || other.isTmpToken == isTmpToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,token,refreshToken,expireAt,isTmpToken,user);
}

@override
String toString() {
    return 'SessionApiModel(token: $token, refreshToken: $refreshToken, expireAt: $expireAt, isTmpToken: $isTmpToken, user: $user)';
}


}

/// @nodoc
abstract mixin class _$SessionApiModelCopyWith<$Res> implements $SessionApiModelCopyWith<$Res> {
  factory _$SessionApiModelCopyWith(_SessionApiModel value, $Res Function(_SessionApiModel) _then) = __$SessionApiModelCopyWithImpl;
@override @useResult
$Res call({
 String token, String? refreshToken, int? expireAt, bool? isTmpToken, UserApiModel? user
});


@override $UserApiModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$SessionApiModelCopyWithImpl<$Res>
    implements _$SessionApiModelCopyWith<$Res> {
  __$SessionApiModelCopyWithImpl(this._self, this._then);

  final _SessionApiModel _self;
  final $Res Function(_SessionApiModel) _then;

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? refreshToken = freezed,Object? expireAt = freezed,Object? isTmpToken = freezed,Object? user = freezed,}) {
  return _then(_SessionApiModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as int?,isTmpToken: freezed == isTmpToken ? _self.isTmpToken : isTmpToken // ignore: cast_nullable_to_non_nullable
as bool?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserApiModel?,
  ));
}

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserApiModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserApiModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
