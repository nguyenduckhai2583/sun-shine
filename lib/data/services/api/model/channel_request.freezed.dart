// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelUpdateRequest {

 String? get name; bool? get isPrivate;
/// Create a copy of ChannelUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelUpdateRequestCopyWith<ChannelUpdateRequest> get copyWith => _$ChannelUpdateRequestCopyWithImpl<ChannelUpdateRequest>(this as ChannelUpdateRequest, _$identity);

  /// Serializes this ChannelUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelUpdateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isPrivate);

@override
String toString() {
  return 'ChannelUpdateRequest(name: $name, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class $ChannelUpdateRequestCopyWith<$Res>  {
  factory $ChannelUpdateRequestCopyWith(ChannelUpdateRequest value, $Res Function(ChannelUpdateRequest) _then) = _$ChannelUpdateRequestCopyWithImpl;
@useResult
$Res call({
 String? name, bool? isPrivate
});




}
/// @nodoc
class _$ChannelUpdateRequestCopyWithImpl<$Res>
    implements $ChannelUpdateRequestCopyWith<$Res> {
  _$ChannelUpdateRequestCopyWithImpl(this._self, this._then);

  final ChannelUpdateRequest _self;
  final $Res Function(ChannelUpdateRequest) _then;

/// Create a copy of ChannelUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? isPrivate = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: freezed == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelUpdateRequest].
extension ChannelUpdateRequestPatterns on ChannelUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChannelUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  bool? isPrivate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelUpdateRequest() when $default != null:
return $default(_that.name,_that.isPrivate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  bool? isPrivate)  $default,) {final _that = this;
switch (_that) {
case _ChannelUpdateRequest():
return $default(_that.name,_that.isPrivate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  bool? isPrivate)?  $default,) {final _that = this;
switch (_that) {
case _ChannelUpdateRequest() when $default != null:
return $default(_that.name,_that.isPrivate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _ChannelUpdateRequest implements ChannelUpdateRequest {
  const _ChannelUpdateRequest({this.name, this.isPrivate});
  factory _ChannelUpdateRequest.fromJson(Map<String, dynamic> json) => _$ChannelUpdateRequestFromJson(json);

@override final  String? name;
@override final  bool? isPrivate;

/// Create a copy of ChannelUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelUpdateRequestCopyWith<_ChannelUpdateRequest> get copyWith => __$ChannelUpdateRequestCopyWithImpl<_ChannelUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChannelUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelUpdateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isPrivate);

@override
String toString() {
  return 'ChannelUpdateRequest(name: $name, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class _$ChannelUpdateRequestCopyWith<$Res> implements $ChannelUpdateRequestCopyWith<$Res> {
  factory _$ChannelUpdateRequestCopyWith(_ChannelUpdateRequest value, $Res Function(_ChannelUpdateRequest) _then) = __$ChannelUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, bool? isPrivate
});




}
/// @nodoc
class __$ChannelUpdateRequestCopyWithImpl<$Res>
    implements _$ChannelUpdateRequestCopyWith<$Res> {
  __$ChannelUpdateRequestCopyWithImpl(this._self, this._then);

  final _ChannelUpdateRequest _self;
  final $Res Function(_ChannelUpdateRequest) _then;

/// Create a copy of ChannelUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? isPrivate = freezed,}) {
  return _then(_ChannelUpdateRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: freezed == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
