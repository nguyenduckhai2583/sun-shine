// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectApiModel {

 String get id; String get name; String get key;@JsonKey(name: 'open_tasks') int get openTasks;
/// Create a copy of ProjectApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectApiModelCopyWith<ProjectApiModel> get copyWith => _$ProjectApiModelCopyWithImpl<ProjectApiModel>(this as ProjectApiModel, _$identity);

  /// Serializes this ProjectApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectApiModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.openTasks, _this.openTasks) || other.openTasks == _this.openTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectApiModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.key,_this.openTasks);
}

@override
String toString() {
  final _this = this as ProjectApiModel;
  return 'ProjectApiModel(id: ${_this.id}, name: ${_this.name}, key: ${_this.key}, openTasks: ${_this.openTasks})';
}


}

/// @nodoc
abstract mixin class $ProjectApiModelCopyWith<$Res>  {
  factory $ProjectApiModelCopyWith(ProjectApiModel value, $Res Function(ProjectApiModel) _then) = _$ProjectApiModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String key,@JsonKey(name: 'open_tasks') int openTasks
});




}
/// @nodoc
class _$ProjectApiModelCopyWithImpl<$Res>
    implements $ProjectApiModelCopyWith<$Res> {
  _$ProjectApiModelCopyWithImpl(this._self, this._then);

  final ProjectApiModel _self;
  final $Res Function(ProjectApiModel) _then;

/// Create a copy of ProjectApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? key = null,Object? openTasks = null,}) {
  return _then(ProjectApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectApiModel].
extension ProjectApiModelPatterns on ProjectApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectApiModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String key, @JsonKey(name: 'open_tasks')  int openTasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectApiModel() when $default != null:
return $default(_that.id,_that.name,_that.key,_that.openTasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String key, @JsonKey(name: 'open_tasks')  int openTasks)  $default,) {final _that = this;
switch (_that) {
case _ProjectApiModel():
return $default(_that.id,_that.name,_that.key,_that.openTasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String key, @JsonKey(name: 'open_tasks')  int openTasks)?  $default,) {final _that = this;
switch (_that) {
case _ProjectApiModel() when $default != null:
return $default(_that.id,_that.name,_that.key,_that.openTasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectApiModel implements ProjectApiModel {
  const _ProjectApiModel({required this.id, required this.name, required this.key, @JsonKey(name: 'open_tasks') this.openTasks = 0});
  factory _ProjectApiModel.fromJson(Map<String, dynamic> json) => _$ProjectApiModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String key;
@override@JsonKey(name: 'open_tasks') final  int openTasks;

/// Create a copy of ProjectApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectApiModelCopyWith<_ProjectApiModel> get copyWith => __$ProjectApiModelCopyWithImpl<_ProjectApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.key, key) || other.key == key)&&(identical(other.openTasks, openTasks) || other.openTasks == openTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,key,openTasks);
}

@override
String toString() {
    return 'ProjectApiModel(id: $id, name: $name, key: $key, openTasks: $openTasks)';
}


}

/// @nodoc
abstract mixin class _$ProjectApiModelCopyWith<$Res> implements $ProjectApiModelCopyWith<$Res> {
  factory _$ProjectApiModelCopyWith(_ProjectApiModel value, $Res Function(_ProjectApiModel) _then) = __$ProjectApiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String key,@JsonKey(name: 'open_tasks') int openTasks
});




}
/// @nodoc
class __$ProjectApiModelCopyWithImpl<$Res>
    implements _$ProjectApiModelCopyWith<$Res> {
  __$ProjectApiModelCopyWithImpl(this._self, this._then);

  final _ProjectApiModel _self;
  final $Res Function(_ProjectApiModel) _then;

/// Create a copy of ProjectApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? key = null,Object? openTasks = null,}) {
  return _then(_ProjectApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
