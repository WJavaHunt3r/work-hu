// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneralNotificationModel {

 num? get id; String get title; String get body;/// Target roles; empty = all users.
 List<num> get roleIds; String? get sentByName; DateTime? get sentDateTime; int get recipientUsers; int get delivered; int get failed;
/// Create a copy of GeneralNotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralNotificationModelCopyWith<GeneralNotificationModel> get copyWith => _$GeneralNotificationModelCopyWithImpl<GeneralNotificationModel>(this as GeneralNotificationModel, _$identity);

  /// Serializes this GeneralNotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GeneralNotificationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralNotificationModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.roleIds, _this.roleIds)&&(identical(other.sentByName, _this.sentByName) || other.sentByName == _this.sentByName)&&(identical(other.sentDateTime, _this.sentDateTime) || other.sentDateTime == _this.sentDateTime)&&(identical(other.recipientUsers, _this.recipientUsers) || other.recipientUsers == _this.recipientUsers)&&(identical(other.delivered, _this.delivered) || other.delivered == _this.delivered)&&(identical(other.failed, _this.failed) || other.failed == _this.failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GeneralNotificationModel;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,const DeepCollectionEquality().hash(_this.roleIds),_this.sentByName,_this.sentDateTime,_this.recipientUsers,_this.delivered,_this.failed);
}

@override
String toString() {
  final _this = this as GeneralNotificationModel;
  return 'GeneralNotificationModel(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, roleIds: ${_this.roleIds}, sentByName: ${_this.sentByName}, sentDateTime: ${_this.sentDateTime}, recipientUsers: ${_this.recipientUsers}, delivered: ${_this.delivered}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $GeneralNotificationModelCopyWith<$Res>  {
  factory $GeneralNotificationModelCopyWith(GeneralNotificationModel value, $Res Function(GeneralNotificationModel) _then) = _$GeneralNotificationModelCopyWithImpl;
@useResult
$Res call({
 num? id, String title, String body, List<num> roleIds, String? sentByName, DateTime? sentDateTime, int recipientUsers, int delivered, int failed
});




}
/// @nodoc
class _$GeneralNotificationModelCopyWithImpl<$Res>
    implements $GeneralNotificationModelCopyWith<$Res> {
  _$GeneralNotificationModelCopyWithImpl(this._self, this._then);

  final GeneralNotificationModel _self;
  final $Res Function(GeneralNotificationModel) _then;

/// Create a copy of GeneralNotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? body = null,Object? roleIds = null,Object? sentByName = freezed,Object? sentDateTime = freezed,Object? recipientUsers = null,Object? delivered = null,Object? failed = null,}) {
  return _then(GeneralNotificationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,roleIds: null == roleIds ? _self.roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<num>,sentByName: freezed == sentByName ? _self.sentByName : sentByName // ignore: cast_nullable_to_non_nullable
as String?,sentDateTime: freezed == sentDateTime ? _self.sentDateTime : sentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,recipientUsers: null == recipientUsers ? _self.recipientUsers : recipientUsers // ignore: cast_nullable_to_non_nullable
as int,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralNotificationModel].
extension GeneralNotificationModelPatterns on GeneralNotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralNotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralNotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralNotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _GeneralNotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralNotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralNotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? id,  String title,  String body,  List<num> roleIds,  String? sentByName,  DateTime? sentDateTime,  int recipientUsers,  int delivered,  int failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralNotificationModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.roleIds,_that.sentByName,_that.sentDateTime,_that.recipientUsers,_that.delivered,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? id,  String title,  String body,  List<num> roleIds,  String? sentByName,  DateTime? sentDateTime,  int recipientUsers,  int delivered,  int failed)  $default,) {final _that = this;
switch (_that) {
case _GeneralNotificationModel():
return $default(_that.id,_that.title,_that.body,_that.roleIds,_that.sentByName,_that.sentDateTime,_that.recipientUsers,_that.delivered,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? id,  String title,  String body,  List<num> roleIds,  String? sentByName,  DateTime? sentDateTime,  int recipientUsers,  int delivered,  int failed)?  $default,) {final _that = this;
switch (_that) {
case _GeneralNotificationModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.roleIds,_that.sentByName,_that.sentDateTime,_that.recipientUsers,_that.delivered,_that.failed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneralNotificationModel implements GeneralNotificationModel {
  const _GeneralNotificationModel({this.id, required this.title, required this.body,  List<num> roleIds = const [], this.sentByName, this.sentDateTime, this.recipientUsers = 0, this.delivered = 0, this.failed = 0}): _roleIds = roleIds;
  factory _GeneralNotificationModel.fromJson(Map<String, dynamic> json) => _$GeneralNotificationModelFromJson(json);

@override final  num? id;
@override final  String title;
@override final  String body;
/// Target roles; empty = all users.
 final  List<num> _roleIds;
/// Target roles; empty = all users.
@override@JsonKey() List<num> get roleIds {
  if (_roleIds is EqualUnmodifiableListView) return _roleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roleIds);
}

@override final  String? sentByName;
@override final  DateTime? sentDateTime;
@override@JsonKey() final  int recipientUsers;
@override@JsonKey() final  int delivered;
@override@JsonKey() final  int failed;

/// Create a copy of GeneralNotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralNotificationModelCopyWith<_GeneralNotificationModel> get copyWith => __$GeneralNotificationModelCopyWithImpl<_GeneralNotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneralNotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralNotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.roleIds, _roleIds)&&(identical(other.sentByName, sentByName) || other.sentByName == sentByName)&&(identical(other.sentDateTime, sentDateTime) || other.sentDateTime == sentDateTime)&&(identical(other.recipientUsers, recipientUsers) || other.recipientUsers == recipientUsers)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,const DeepCollectionEquality().hash(_roleIds),sentByName,sentDateTime,recipientUsers,delivered,failed);
}

@override
String toString() {
    return 'GeneralNotificationModel(id: $id, title: $title, body: $body, roleIds: $roleIds, sentByName: $sentByName, sentDateTime: $sentDateTime, recipientUsers: $recipientUsers, delivered: $delivered, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$GeneralNotificationModelCopyWith<$Res> implements $GeneralNotificationModelCopyWith<$Res> {
  factory _$GeneralNotificationModelCopyWith(_GeneralNotificationModel value, $Res Function(_GeneralNotificationModel) _then) = __$GeneralNotificationModelCopyWithImpl;
@override @useResult
$Res call({
 num? id, String title, String body, List<num> roleIds, String? sentByName, DateTime? sentDateTime, int recipientUsers, int delivered, int failed
});




}
/// @nodoc
class __$GeneralNotificationModelCopyWithImpl<$Res>
    implements _$GeneralNotificationModelCopyWith<$Res> {
  __$GeneralNotificationModelCopyWithImpl(this._self, this._then);

  final _GeneralNotificationModel _self;
  final $Res Function(_GeneralNotificationModel) _then;

/// Create a copy of GeneralNotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? body = null,Object? roleIds = null,Object? sentByName = freezed,Object? sentDateTime = freezed,Object? recipientUsers = null,Object? delivered = null,Object? failed = null,}) {
  return _then(_GeneralNotificationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,roleIds: null == roleIds ? _self._roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<num>,sentByName: freezed == sentByName ? _self.sentByName : sentByName // ignore: cast_nullable_to_non_nullable
as String?,sentDateTime: freezed == sentDateTime ? _self.sentDateTime : sentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,recipientUsers: null == recipientUsers ? _self.recipientUsers : recipientUsers // ignore: cast_nullable_to_non_nullable
as int,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
