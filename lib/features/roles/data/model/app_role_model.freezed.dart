// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppRoleModel {

 num? get id; String get name; String? get description;/// Permission names; strings so permissions unknown to this app version survive an edit.
 List<String> get permissions; num get userCount;
/// Create a copy of AppRoleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppRoleModelCopyWith<AppRoleModel> get copyWith => _$AppRoleModelCopyWithImpl<AppRoleModel>(this as AppRoleModel, _$identity);

  /// Serializes this AppRoleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppRoleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRoleModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&(identical(other.userCount, _this.userCount) || other.userCount == _this.userCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppRoleModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,const DeepCollectionEquality().hash(_this.permissions),_this.userCount);
}

@override
String toString() {
  final _this = this as AppRoleModel;
  return 'AppRoleModel(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, permissions: ${_this.permissions}, userCount: ${_this.userCount})';
}


}

/// @nodoc
abstract mixin class $AppRoleModelCopyWith<$Res>  {
  factory $AppRoleModelCopyWith(AppRoleModel value, $Res Function(AppRoleModel) _then) = _$AppRoleModelCopyWithImpl;
@useResult
$Res call({
 num? id, String name, String? description, List<String> permissions, num userCount
});




}
/// @nodoc
class _$AppRoleModelCopyWithImpl<$Res>
    implements $AppRoleModelCopyWith<$Res> {
  _$AppRoleModelCopyWithImpl(this._self, this._then);

  final AppRoleModel _self;
  final $Res Function(AppRoleModel) _then;

/// Create a copy of AppRoleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? permissions = null,Object? userCount = null,}) {
  return _then(AppRoleModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,userCount: null == userCount ? _self.userCount : userCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AppRoleModel].
extension AppRoleModelPatterns on AppRoleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppRoleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppRoleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppRoleModel value)  $default,){
final _that = this;
switch (_that) {
case _AppRoleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppRoleModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppRoleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? id,  String name,  String? description,  List<String> permissions,  num userCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppRoleModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.userCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? id,  String name,  String? description,  List<String> permissions,  num userCount)  $default,) {final _that = this;
switch (_that) {
case _AppRoleModel():
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.userCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? id,  String name,  String? description,  List<String> permissions,  num userCount)?  $default,) {final _that = this;
switch (_that) {
case _AppRoleModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.permissions,_that.userCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppRoleModel extends AppRoleModel {
  const _AppRoleModel({this.id, required this.name, this.description,  List<String> permissions = const [], this.userCount = 0}): _permissions = permissions,super._();
  factory _AppRoleModel.fromJson(Map<String, dynamic> json) => _$AppRoleModelFromJson(json);

@override final  num? id;
@override final  String name;
@override final  String? description;
/// Permission names; strings so permissions unknown to this app version survive an edit.
 final  List<String> _permissions;
/// Permission names; strings so permissions unknown to this app version survive an edit.
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override@JsonKey() final  num userCount;

/// Create a copy of AppRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppRoleModelCopyWith<_AppRoleModel> get copyWith => __$AppRoleModelCopyWithImpl<_AppRoleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppRoleModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppRoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&(identical(other.userCount, userCount) || other.userCount == userCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_permissions),userCount);
}

@override
String toString() {
    return 'AppRoleModel(id: $id, name: $name, description: $description, permissions: $permissions, userCount: $userCount)';
}


}

/// @nodoc
abstract mixin class _$AppRoleModelCopyWith<$Res> implements $AppRoleModelCopyWith<$Res> {
  factory _$AppRoleModelCopyWith(_AppRoleModel value, $Res Function(_AppRoleModel) _then) = __$AppRoleModelCopyWithImpl;
@override @useResult
$Res call({
 num? id, String name, String? description, List<String> permissions, num userCount
});




}
/// @nodoc
class __$AppRoleModelCopyWithImpl<$Res>
    implements _$AppRoleModelCopyWith<$Res> {
  __$AppRoleModelCopyWithImpl(this._self, this._then);

  final _AppRoleModel _self;
  final $Res Function(_AppRoleModel) _then;

/// Create a copy of AppRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? permissions = null,Object? userCount = null,}) {
  return _then(_AppRoleModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,userCount: null == userCount ? _self.userCount : userCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
