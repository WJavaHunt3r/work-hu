// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationScheduleModel {

 num? get id; String get type; String? get title; String? get body;/// `MONDAY` ... `SUNDAY`.
 String get dayOfWeek;/// `HH:mm` (the backend may add seconds), server time.
 String get time; bool get active; List<num> get roleIds; DateTime? get lastSentDateTime;
/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationScheduleModelCopyWith<NotificationScheduleModel> get copyWith => _$NotificationScheduleModelCopyWithImpl<NotificationScheduleModel>(this as NotificationScheduleModel, _$identity);

  /// Serializes this NotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationScheduleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationScheduleModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.dayOfWeek, _this.dayOfWeek) || other.dayOfWeek == _this.dayOfWeek)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.active, _this.active) || other.active == _this.active)&&const DeepCollectionEquality().equals(other.roleIds, _this.roleIds)&&(identical(other.lastSentDateTime, _this.lastSentDateTime) || other.lastSentDateTime == _this.lastSentDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationScheduleModel;
  return Object.hash(runtimeType,_this.id,_this.type,_this.title,_this.body,_this.dayOfWeek,_this.time,_this.active,const DeepCollectionEquality().hash(_this.roleIds),_this.lastSentDateTime);
}

@override
String toString() {
  final _this = this as NotificationScheduleModel;
  return 'NotificationScheduleModel(id: ${_this.id}, type: ${_this.type}, title: ${_this.title}, body: ${_this.body}, dayOfWeek: ${_this.dayOfWeek}, time: ${_this.time}, active: ${_this.active}, roleIds: ${_this.roleIds}, lastSentDateTime: ${_this.lastSentDateTime})';
}


}

/// @nodoc
abstract mixin class $NotificationScheduleModelCopyWith<$Res>  {
  factory $NotificationScheduleModelCopyWith(NotificationScheduleModel value, $Res Function(NotificationScheduleModel) _then) = _$NotificationScheduleModelCopyWithImpl;
@useResult
$Res call({
 num? id, String type, String? title, String? body, String dayOfWeek, String time, bool active, List<num> roleIds, DateTime? lastSentDateTime
});




}
/// @nodoc
class _$NotificationScheduleModelCopyWithImpl<$Res>
    implements $NotificationScheduleModelCopyWith<$Res> {
  _$NotificationScheduleModelCopyWithImpl(this._self, this._then);

  final NotificationScheduleModel _self;
  final $Res Function(NotificationScheduleModel) _then;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = null,Object? title = freezed,Object? body = freezed,Object? dayOfWeek = null,Object? time = null,Object? active = null,Object? roleIds = null,Object? lastSentDateTime = freezed,}) {
  return _then(NotificationScheduleModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,roleIds: null == roleIds ? _self.roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<num>,lastSentDateTime: freezed == lastSentDateTime ? _self.lastSentDateTime : lastSentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationScheduleModel].
extension NotificationScheduleModelPatterns on NotificationScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? id,  String type,  String? title,  String? body,  String dayOfWeek,  String time,  bool active,  List<num> roleIds,  DateTime? lastSentDateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.dayOfWeek,_that.time,_that.active,_that.roleIds,_that.lastSentDateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? id,  String type,  String? title,  String? body,  String dayOfWeek,  String time,  bool active,  List<num> roleIds,  DateTime? lastSentDateTime)  $default,) {final _that = this;
switch (_that) {
case _NotificationScheduleModel():
return $default(_that.id,_that.type,_that.title,_that.body,_that.dayOfWeek,_that.time,_that.active,_that.roleIds,_that.lastSentDateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? id,  String type,  String? title,  String? body,  String dayOfWeek,  String time,  bool active,  List<num> roleIds,  DateTime? lastSentDateTime)?  $default,) {final _that = this;
switch (_that) {
case _NotificationScheduleModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.dayOfWeek,_that.time,_that.active,_that.roleIds,_that.lastSentDateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationScheduleModel extends NotificationScheduleModel {
  const _NotificationScheduleModel({this.id, this.type = 'WEEKLY', this.title, this.body, this.dayOfWeek = 'MONDAY', this.time = '17:00', this.active = true,  List<num> roleIds = const [], this.lastSentDateTime}): _roleIds = roleIds,super._();
  factory _NotificationScheduleModel.fromJson(Map<String, dynamic> json) => _$NotificationScheduleModelFromJson(json);

@override final  num? id;
@override@JsonKey() final  String type;
@override final  String? title;
@override final  String? body;
/// `MONDAY` ... `SUNDAY`.
@override@JsonKey() final  String dayOfWeek;
/// `HH:mm` (the backend may add seconds), server time.
@override@JsonKey() final  String time;
@override@JsonKey() final  bool active;
 final  List<num> _roleIds;
@override@JsonKey() List<num> get roleIds {
  if (_roleIds is EqualUnmodifiableListView) return _roleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roleIds);
}

@override final  DateTime? lastSentDateTime;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationScheduleModelCopyWith<_NotificationScheduleModel> get copyWith => __$NotificationScheduleModelCopyWithImpl<_NotificationScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.time, time) || other.time == time)&&(identical(other.active, active) || other.active == active)&&const DeepCollectionEquality().equals(other.roleIds, _roleIds)&&(identical(other.lastSentDateTime, lastSentDateTime) || other.lastSentDateTime == lastSentDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,title,body,dayOfWeek,time,active,const DeepCollectionEquality().hash(_roleIds),lastSentDateTime);
}

@override
String toString() {
    return 'NotificationScheduleModel(id: $id, type: $type, title: $title, body: $body, dayOfWeek: $dayOfWeek, time: $time, active: $active, roleIds: $roleIds, lastSentDateTime: $lastSentDateTime)';
}


}

/// @nodoc
abstract mixin class _$NotificationScheduleModelCopyWith<$Res> implements $NotificationScheduleModelCopyWith<$Res> {
  factory _$NotificationScheduleModelCopyWith(_NotificationScheduleModel value, $Res Function(_NotificationScheduleModel) _then) = __$NotificationScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 num? id, String type, String? title, String? body, String dayOfWeek, String time, bool active, List<num> roleIds, DateTime? lastSentDateTime
});




}
/// @nodoc
class __$NotificationScheduleModelCopyWithImpl<$Res>
    implements _$NotificationScheduleModelCopyWith<$Res> {
  __$NotificationScheduleModelCopyWithImpl(this._self, this._then);

  final _NotificationScheduleModel _self;
  final $Res Function(_NotificationScheduleModel) _then;

/// Create a copy of NotificationScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = null,Object? title = freezed,Object? body = freezed,Object? dayOfWeek = null,Object? time = null,Object? active = null,Object? roleIds = null,Object? lastSentDateTime = freezed,}) {
  return _then(_NotificationScheduleModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,roleIds: null == roleIds ? _self._roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<num>,lastSentDateTime: freezed == lastSentDateTime ? _self.lastSentDateTime : lastSentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
