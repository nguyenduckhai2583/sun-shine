// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelApiModel {

 String get id; String? get name; bool get isPrivate; bool get isEncrypted;
/// Create a copy of ChannelApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelApiModelCopyWith<ChannelApiModel> get copyWith => _$ChannelApiModelCopyWithImpl<ChannelApiModel>(this as ChannelApiModel, _$identity);

  /// Serializes this ChannelApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isPrivate,isEncrypted);

@override
String toString() {
  return 'ChannelApiModel(id: $id, name: $name, isPrivate: $isPrivate, isEncrypted: $isEncrypted)';
}


}

/// @nodoc
abstract mixin class $ChannelApiModelCopyWith<$Res>  {
  factory $ChannelApiModelCopyWith(ChannelApiModel value, $Res Function(ChannelApiModel) _then) = _$ChannelApiModelCopyWithImpl;
@useResult
$Res call({
 String id, String? name, bool isPrivate, bool isEncrypted
});




}
/// @nodoc
class _$ChannelApiModelCopyWithImpl<$Res>
    implements $ChannelApiModelCopyWith<$Res> {
  _$ChannelApiModelCopyWithImpl(this._self, this._then);

  final ChannelApiModel _self;
  final $Res Function(ChannelApiModel) _then;

/// Create a copy of ChannelApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? isPrivate = null,Object? isEncrypted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelApiModel].
extension ChannelApiModelPatterns on ChannelApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelApiModel value)  $default,){
final _that = this;
switch (_that) {
case _ChannelApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  bool isPrivate,  bool isEncrypted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelApiModel() when $default != null:
return $default(_that.id,_that.name,_that.isPrivate,_that.isEncrypted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  bool isPrivate,  bool isEncrypted)  $default,) {final _that = this;
switch (_that) {
case _ChannelApiModel():
return $default(_that.id,_that.name,_that.isPrivate,_that.isEncrypted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  bool isPrivate,  bool isEncrypted)?  $default,) {final _that = this;
switch (_that) {
case _ChannelApiModel() when $default != null:
return $default(_that.id,_that.name,_that.isPrivate,_that.isEncrypted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChannelApiModel implements ChannelApiModel {
  const _ChannelApiModel({required this.id, this.name, this.isPrivate = false, this.isEncrypted = false});
  factory _ChannelApiModel.fromJson(Map<String, dynamic> json) => _$ChannelApiModelFromJson(json);

@override final  String id;
@override final  String? name;
@override@JsonKey() final  bool isPrivate;
@override@JsonKey() final  bool isEncrypted;

/// Create a copy of ChannelApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelApiModelCopyWith<_ChannelApiModel> get copyWith => __$ChannelApiModelCopyWithImpl<_ChannelApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChannelApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isPrivate,isEncrypted);

@override
String toString() {
  return 'ChannelApiModel(id: $id, name: $name, isPrivate: $isPrivate, isEncrypted: $isEncrypted)';
}


}

/// @nodoc
abstract mixin class _$ChannelApiModelCopyWith<$Res> implements $ChannelApiModelCopyWith<$Res> {
  factory _$ChannelApiModelCopyWith(_ChannelApiModel value, $Res Function(_ChannelApiModel) _then) = __$ChannelApiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, bool isPrivate, bool isEncrypted
});




}
/// @nodoc
class __$ChannelApiModelCopyWithImpl<$Res>
    implements _$ChannelApiModelCopyWith<$Res> {
  __$ChannelApiModelCopyWithImpl(this._self, this._then);

  final _ChannelApiModel _self;
  final $Res Function(_ChannelApiModel) _then;

/// Create a copy of ChannelApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? isPrivate = null,Object? isEncrypted = null,}) {
  return _then(_ChannelApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
