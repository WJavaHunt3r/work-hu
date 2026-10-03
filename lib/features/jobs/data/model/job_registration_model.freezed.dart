// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_registration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobRegistrationModel {

 num? get id; num get jobId; num get userId; String? get userName; num? get registeredById; String? get registeredByName;/// Only sent to the registrant, their parent, the registrar and the people running the job.
 String? get comment; JobRegistrationStatus get status;/// 1 = next to be promoted; only for waitlisted registrations.
 int? get waitlistPosition; DateTime? get registeredDateTime; DateTime? get cancelledDateTime; double get hours;
/// Create a copy of JobRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRegistrationModelCopyWith<JobRegistrationModel> get copyWith => _$JobRegistrationModelCopyWithImpl<JobRegistrationModel>(this as JobRegistrationModel, _$identity);

  /// Serializes this JobRegistrationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobRegistrationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRegistrationModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.jobId, _this.jobId) || other.jobId == _this.jobId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.registeredById, _this.registeredById) || other.registeredById == _this.registeredById)&&(identical(other.registeredByName, _this.registeredByName) || other.registeredByName == _this.registeredByName)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.waitlistPosition, _this.waitlistPosition) || other.waitlistPosition == _this.waitlistPosition)&&(identical(other.registeredDateTime, _this.registeredDateTime) || other.registeredDateTime == _this.registeredDateTime)&&(identical(other.cancelledDateTime, _this.cancelledDateTime) || other.cancelledDateTime == _this.cancelledDateTime)&&(identical(other.hours, _this.hours) || other.hours == _this.hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobRegistrationModel;
  return Object.hash(runtimeType,_this.id,_this.jobId,_this.userId,_this.userName,_this.registeredById,_this.registeredByName,_this.comment,_this.status,_this.waitlistPosition,_this.registeredDateTime,_this.cancelledDateTime,_this.hours);
}

@override
String toString() {
  final _this = this as JobRegistrationModel;
  return 'JobRegistrationModel(id: ${_this.id}, jobId: ${_this.jobId}, userId: ${_this.userId}, userName: ${_this.userName}, registeredById: ${_this.registeredById}, registeredByName: ${_this.registeredByName}, comment: ${_this.comment}, status: ${_this.status}, waitlistPosition: ${_this.waitlistPosition}, registeredDateTime: ${_this.registeredDateTime}, cancelledDateTime: ${_this.cancelledDateTime}, hours: ${_this.hours})';
}


}

/// @nodoc
abstract mixin class $JobRegistrationModelCopyWith<$Res>  {
  factory $JobRegistrationModelCopyWith(JobRegistrationModel value, $Res Function(JobRegistrationModel) _then) = _$JobRegistrationModelCopyWithImpl;
@useResult
$Res call({
 num? id, num jobId, num userId, String? userName, num? registeredById, String? registeredByName, String? comment, JobRegistrationStatus status, int? waitlistPosition, DateTime? registeredDateTime, DateTime? cancelledDateTime, double hours
});




}
/// @nodoc
class _$JobRegistrationModelCopyWithImpl<$Res>
    implements $JobRegistrationModelCopyWith<$Res> {
  _$JobRegistrationModelCopyWithImpl(this._self, this._then);

  final JobRegistrationModel _self;
  final $Res Function(JobRegistrationModel) _then;

/// Create a copy of JobRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? jobId = null,Object? userId = null,Object? userName = freezed,Object? registeredById = freezed,Object? registeredByName = freezed,Object? comment = freezed,Object? status = null,Object? waitlistPosition = freezed,Object? registeredDateTime = freezed,Object? cancelledDateTime = freezed,Object? hours = null,}) {
  return _then(JobRegistrationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as num,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as num,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,registeredById: freezed == registeredById ? _self.registeredById : registeredById // ignore: cast_nullable_to_non_nullable
as num?,registeredByName: freezed == registeredByName ? _self.registeredByName : registeredByName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobRegistrationStatus,waitlistPosition: freezed == waitlistPosition ? _self.waitlistPosition : waitlistPosition // ignore: cast_nullable_to_non_nullable
as int?,registeredDateTime: freezed == registeredDateTime ? _self.registeredDateTime : registeredDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledDateTime: freezed == cancelledDateTime ? _self.cancelledDateTime : cancelledDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [JobRegistrationModel].
extension JobRegistrationModelPatterns on JobRegistrationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobRegistrationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobRegistrationModel value)  $default,){
final _that = this;
switch (_that) {
case _JobRegistrationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobRegistrationModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? id,  num jobId,  num userId,  String? userName,  num? registeredById,  String? registeredByName,  String? comment,  JobRegistrationStatus status,  int? waitlistPosition,  DateTime? registeredDateTime,  DateTime? cancelledDateTime,  double hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobRegistrationModel() when $default != null:
return $default(_that.id,_that.jobId,_that.userId,_that.userName,_that.registeredById,_that.registeredByName,_that.comment,_that.status,_that.waitlistPosition,_that.registeredDateTime,_that.cancelledDateTime,_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? id,  num jobId,  num userId,  String? userName,  num? registeredById,  String? registeredByName,  String? comment,  JobRegistrationStatus status,  int? waitlistPosition,  DateTime? registeredDateTime,  DateTime? cancelledDateTime,  double hours)  $default,) {final _that = this;
switch (_that) {
case _JobRegistrationModel():
return $default(_that.id,_that.jobId,_that.userId,_that.userName,_that.registeredById,_that.registeredByName,_that.comment,_that.status,_that.waitlistPosition,_that.registeredDateTime,_that.cancelledDateTime,_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? id,  num jobId,  num userId,  String? userName,  num? registeredById,  String? registeredByName,  String? comment,  JobRegistrationStatus status,  int? waitlistPosition,  DateTime? registeredDateTime,  DateTime? cancelledDateTime,  double hours)?  $default,) {final _that = this;
switch (_that) {
case _JobRegistrationModel() when $default != null:
return $default(_that.id,_that.jobId,_that.userId,_that.userName,_that.registeredById,_that.registeredByName,_that.comment,_that.status,_that.waitlistPosition,_that.registeredDateTime,_that.cancelledDateTime,_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobRegistrationModel extends JobRegistrationModel {
  const _JobRegistrationModel({this.id, required this.jobId, required this.userId, this.userName, this.registeredById, this.registeredByName, this.comment, required this.status, this.waitlistPosition, this.registeredDateTime, this.cancelledDateTime, this.hours = 0}): super._();
  factory _JobRegistrationModel.fromJson(Map<String, dynamic> json) => _$JobRegistrationModelFromJson(json);

@override final  num? id;
@override final  num jobId;
@override final  num userId;
@override final  String? userName;
@override final  num? registeredById;
@override final  String? registeredByName;
/// Only sent to the registrant, their parent, the registrar and the people running the job.
@override final  String? comment;
@override final  JobRegistrationStatus status;
/// 1 = next to be promoted; only for waitlisted registrations.
@override final  int? waitlistPosition;
@override final  DateTime? registeredDateTime;
@override final  DateTime? cancelledDateTime;
@override@JsonKey() final  double hours;

/// Create a copy of JobRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobRegistrationModelCopyWith<_JobRegistrationModel> get copyWith => __$JobRegistrationModelCopyWithImpl<_JobRegistrationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobRegistrationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobRegistrationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.registeredById, registeredById) || other.registeredById == registeredById)&&(identical(other.registeredByName, registeredByName) || other.registeredByName == registeredByName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.status, status) || other.status == status)&&(identical(other.waitlistPosition, waitlistPosition) || other.waitlistPosition == waitlistPosition)&&(identical(other.registeredDateTime, registeredDateTime) || other.registeredDateTime == registeredDateTime)&&(identical(other.cancelledDateTime, cancelledDateTime) || other.cancelledDateTime == cancelledDateTime)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,jobId,userId,userName,registeredById,registeredByName,comment,status,waitlistPosition,registeredDateTime,cancelledDateTime,hours);
}

@override
String toString() {
    return 'JobRegistrationModel(id: $id, jobId: $jobId, userId: $userId, userName: $userName, registeredById: $registeredById, registeredByName: $registeredByName, comment: $comment, status: $status, waitlistPosition: $waitlistPosition, registeredDateTime: $registeredDateTime, cancelledDateTime: $cancelledDateTime, hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$JobRegistrationModelCopyWith<$Res> implements $JobRegistrationModelCopyWith<$Res> {
  factory _$JobRegistrationModelCopyWith(_JobRegistrationModel value, $Res Function(_JobRegistrationModel) _then) = __$JobRegistrationModelCopyWithImpl;
@override @useResult
$Res call({
 num? id, num jobId, num userId, String? userName, num? registeredById, String? registeredByName, String? comment, JobRegistrationStatus status, int? waitlistPosition, DateTime? registeredDateTime, DateTime? cancelledDateTime, double hours
});




}
/// @nodoc
class __$JobRegistrationModelCopyWithImpl<$Res>
    implements _$JobRegistrationModelCopyWith<$Res> {
  __$JobRegistrationModelCopyWithImpl(this._self, this._then);

  final _JobRegistrationModel _self;
  final $Res Function(_JobRegistrationModel) _then;

/// Create a copy of JobRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? jobId = null,Object? userId = null,Object? userName = freezed,Object? registeredById = freezed,Object? registeredByName = freezed,Object? comment = freezed,Object? status = null,Object? waitlistPosition = freezed,Object? registeredDateTime = freezed,Object? cancelledDateTime = freezed,Object? hours = null,}) {
  return _then(_JobRegistrationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as num,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as num,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,registeredById: freezed == registeredById ? _self.registeredById : registeredById // ignore: cast_nullable_to_non_nullable
as num?,registeredByName: freezed == registeredByName ? _self.registeredByName : registeredByName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobRegistrationStatus,waitlistPosition: freezed == waitlistPosition ? _self.waitlistPosition : waitlistPosition // ignore: cast_nullable_to_non_nullable
as int?,registeredDateTime: freezed == registeredDateTime ? _self.registeredDateTime : registeredDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledDateTime: freezed == cancelledDateTime ? _self.cancelledDateTime : cancelledDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
