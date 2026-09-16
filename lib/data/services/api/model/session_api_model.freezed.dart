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

@JsonKey(name: 'user_id') String get userId; String get email;@JsonKey(name: 'access_token') String get accessToken;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionApiModel&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionApiModel;
  return Object.hash(runtimeType,_this.userId,_this.email,_this.accessToken);
}

@override
String toString() {
  final _this = this as SessionApiModel;
  return 'SessionApiModel(userId: ${_this.userId}, email: ${_this.email}, accessToken: ${_this.accessToken})';
}


}

/// @nodoc
abstract mixin class $SessionApiModelCopyWith<$Res>  {
  factory $SessionApiModelCopyWith(SessionApiModel value, $Res Function(SessionApiModel) _then) = _$SessionApiModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String email,@JsonKey(name: 'access_token') String accessToken
});




}
/// @nodoc
class _$SessionApiModelCopyWithImpl<$Res>
    implements $SessionApiModelCopyWith<$Res> {
  _$SessionApiModelCopyWithImpl(this._self, this._then);

  final SessionApiModel _self;
  final $Res Function(SessionApiModel) _then;

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? email = null,Object? accessToken = null,}) {
  return _then(SessionApiModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String email, @JsonKey(name: 'access_token')  String accessToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
return $default(_that.userId,_that.email,_that.accessToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String email, @JsonKey(name: 'access_token')  String accessToken)  $default,) {final _that = this;
switch (_that) {
case _SessionApiModel():
return $default(_that.userId,_that.email,_that.accessToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String email, @JsonKey(name: 'access_token')  String accessToken)?  $default,) {final _that = this;
switch (_that) {
case _SessionApiModel() when $default != null:
return $default(_that.userId,_that.email,_that.accessToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionApiModel implements SessionApiModel {
  const _SessionApiModel({@JsonKey(name: 'user_id') required this.userId, required this.email, @JsonKey(name: 'access_token') required this.accessToken});
  factory _SessionApiModel.fromJson(Map<String, dynamic> json) => _$SessionApiModelFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override final  String email;
@override@JsonKey(name: 'access_token') final  String accessToken;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionApiModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,email,accessToken);
}

@override
String toString() {
    return 'SessionApiModel(userId: $userId, email: $email, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class _$SessionApiModelCopyWith<$Res> implements $SessionApiModelCopyWith<$Res> {
  factory _$SessionApiModelCopyWith(_SessionApiModel value, $Res Function(_SessionApiModel) _then) = __$SessionApiModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String email,@JsonKey(name: 'access_token') String accessToken
});




}
/// @nodoc
class __$SessionApiModelCopyWithImpl<$Res>
    implements _$SessionApiModelCopyWith<$Res> {
  __$SessionApiModelCopyWithImpl(this._self, this._then);

  final _SessionApiModel _self;
  final $Res Function(_SessionApiModel) _then;

/// Create a copy of SessionApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? email = null,Object? accessToken = null,}) {
  return _then(_SessionApiModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
