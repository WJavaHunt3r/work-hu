// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobModel {

 num? get id; DateTime get jobDateTime;/// When the job ends; null for jobs created without an end time.
 DateTime? get jobEndDateTime; String get description; num get employerId; num get responsibleId; Account get account; TransactionType get transactionType;/// Registration opens at this time; null means it is open from the start.
 DateTime? get registrationOpensAt;/// Send a "new job" push when registration opens.
 bool get sendNotification;/// Last moment to register; null = no deadline.
 DateTime? get registrationDeadline;/// Registered users can cancel on their own until then; null = no deadline.
 DateTime? get cancellationDeadline;/// False: registered users can't cancel on their own at all.
 bool get cancellationAllowed;/// True: nobody can register until the job is opened again.
 bool get registrationClosed;/// Number of places; null for unlimited.
 int? get maxParticipants; bool get waitlistEnabled; int? get minAge; int? get maxAge;/// Null means open to everyone.
@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? get genderRestriction;/// Only sent when creating: repeats the job on the given weekdays until a date.
@JsonKey(includeIfNull: false) JobRecurrenceModel? get recurrence;/// Shared by the occurrences of a repeating job; null for a single job.
 String? get seriesId; DateTime? get createDateTime; num? get createUserId; String? get createUserName; String? get employerName; String? get responsibleName; JobStatus get status;/// The activity created when the job was completed.
 num? get activityId; DateTime? get completedDateTime; num get registeredCount; num get waitlistCount; bool get full;/// Open for new registrations (or the waitlist) right now.
 bool get registrationOpen;/// Registered users can still cancel on their own.
 bool get cancellationOpen;/// The requesting user's own registration; null if none.
 JobRegistrationStatus? get myRegistrationStatus;
/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobModelCopyWith<JobModel> get copyWith => _$JobModelCopyWithImpl<JobModel>(this as JobModel, _$identity);

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.jobDateTime, _this.jobDateTime) || other.jobDateTime == _this.jobDateTime)&&(identical(other.jobEndDateTime, _this.jobEndDateTime) || other.jobEndDateTime == _this.jobEndDateTime)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.employerId, _this.employerId) || other.employerId == _this.employerId)&&(identical(other.responsibleId, _this.responsibleId) || other.responsibleId == _this.responsibleId)&&(identical(other.account, _this.account) || other.account == _this.account)&&(identical(other.transactionType, _this.transactionType) || other.transactionType == _this.transactionType)&&(identical(other.registrationOpensAt, _this.registrationOpensAt) || other.registrationOpensAt == _this.registrationOpensAt)&&(identical(other.sendNotification, _this.sendNotification) || other.sendNotification == _this.sendNotification)&&(identical(other.registrationDeadline, _this.registrationDeadline) || other.registrationDeadline == _this.registrationDeadline)&&(identical(other.cancellationDeadline, _this.cancellationDeadline) || other.cancellationDeadline == _this.cancellationDeadline)&&(identical(other.cancellationAllowed, _this.cancellationAllowed) || other.cancellationAllowed == _this.cancellationAllowed)&&(identical(other.registrationClosed, _this.registrationClosed) || other.registrationClosed == _this.registrationClosed)&&(identical(other.maxParticipants, _this.maxParticipants) || other.maxParticipants == _this.maxParticipants)&&(identical(other.waitlistEnabled, _this.waitlistEnabled) || other.waitlistEnabled == _this.waitlistEnabled)&&(identical(other.minAge, _this.minAge) || other.minAge == _this.minAge)&&(identical(other.maxAge, _this.maxAge) || other.maxAge == _this.maxAge)&&(identical(other.genderRestriction, _this.genderRestriction) || other.genderRestriction == _this.genderRestriction)&&(identical(other.recurrence, _this.recurrence) || other.recurrence == _this.recurrence)&&(identical(other.seriesId, _this.seriesId) || other.seriesId == _this.seriesId)&&(identical(other.createDateTime, _this.createDateTime) || other.createDateTime == _this.createDateTime)&&(identical(other.createUserId, _this.createUserId) || other.createUserId == _this.createUserId)&&(identical(other.createUserName, _this.createUserName) || other.createUserName == _this.createUserName)&&(identical(other.employerName, _this.employerName) || other.employerName == _this.employerName)&&(identical(other.responsibleName, _this.responsibleName) || other.responsibleName == _this.responsibleName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.activityId, _this.activityId) || other.activityId == _this.activityId)&&(identical(other.completedDateTime, _this.completedDateTime) || other.completedDateTime == _this.completedDateTime)&&(identical(other.registeredCount, _this.registeredCount) || other.registeredCount == _this.registeredCount)&&(identical(other.waitlistCount, _this.waitlistCount) || other.waitlistCount == _this.waitlistCount)&&(identical(other.full, _this.full) || other.full == _this.full)&&(identical(other.registrationOpen, _this.registrationOpen) || other.registrationOpen == _this.registrationOpen)&&(identical(other.cancellationOpen, _this.cancellationOpen) || other.cancellationOpen == _this.cancellationOpen)&&(identical(other.myRegistrationStatus, _this.myRegistrationStatus) || other.myRegistrationStatus == _this.myRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobModel;
  return Object.hashAll([runtimeType,_this.id,_this.jobDateTime,_this.jobEndDateTime,_this.description,_this.employerId,_this.responsibleId,_this.account,_this.transactionType,_this.registrationOpensAt,_this.sendNotification,_this.registrationDeadline,_this.cancellationDeadline,_this.cancellationAllowed,_this.registrationClosed,_this.maxParticipants,_this.waitlistEnabled,_this.minAge,_this.maxAge,_this.genderRestriction,_this.recurrence,_this.seriesId,_this.createDateTime,_this.createUserId,_this.createUserName,_this.employerName,_this.responsibleName,_this.status,_this.activityId,_this.completedDateTime,_this.registeredCount,_this.waitlistCount,_this.full,_this.registrationOpen,_this.cancellationOpen,_this.myRegistrationStatus]);
}

@override
String toString() {
  final _this = this as JobModel;
  return 'JobModel(id: ${_this.id}, jobDateTime: ${_this.jobDateTime}, jobEndDateTime: ${_this.jobEndDateTime}, description: ${_this.description}, employerId: ${_this.employerId}, responsibleId: ${_this.responsibleId}, account: ${_this.account}, transactionType: ${_this.transactionType}, registrationOpensAt: ${_this.registrationOpensAt}, sendNotification: ${_this.sendNotification}, registrationDeadline: ${_this.registrationDeadline}, cancellationDeadline: ${_this.cancellationDeadline}, cancellationAllowed: ${_this.cancellationAllowed}, registrationClosed: ${_this.registrationClosed}, maxParticipants: ${_this.maxParticipants}, waitlistEnabled: ${_this.waitlistEnabled}, minAge: ${_this.minAge}, maxAge: ${_this.maxAge}, genderRestriction: ${_this.genderRestriction}, recurrence: ${_this.recurrence}, seriesId: ${_this.seriesId}, createDateTime: ${_this.createDateTime}, createUserId: ${_this.createUserId}, createUserName: ${_this.createUserName}, employerName: ${_this.employerName}, responsibleName: ${_this.responsibleName}, status: ${_this.status}, activityId: ${_this.activityId}, completedDateTime: ${_this.completedDateTime}, registeredCount: ${_this.registeredCount}, waitlistCount: ${_this.waitlistCount}, full: ${_this.full}, registrationOpen: ${_this.registrationOpen}, cancellationOpen: ${_this.cancellationOpen}, myRegistrationStatus: ${_this.myRegistrationStatus})';
}


}

/// @nodoc
abstract mixin class $JobModelCopyWith<$Res>  {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) _then) = _$JobModelCopyWithImpl;
@useResult
$Res call({
 num? id, DateTime jobDateTime, DateTime? jobEndDateTime, String description, num employerId, num responsibleId, Account account, TransactionType transactionType, DateTime? registrationOpensAt, bool sendNotification, DateTime? registrationDeadline, DateTime? cancellationDeadline, bool cancellationAllowed, bool registrationClosed, int? maxParticipants, bool waitlistEnabled, int? minAge, int? maxAge,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? genderRestriction,@JsonKey(includeIfNull: false) JobRecurrenceModel? recurrence, String? seriesId, DateTime? createDateTime, num? createUserId, String? createUserName, String? employerName, String? responsibleName, JobStatus status, num? activityId, DateTime? completedDateTime, num registeredCount, num waitlistCount, bool full, bool registrationOpen, bool cancellationOpen, JobRegistrationStatus? myRegistrationStatus
});


$JobRecurrenceModelCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$JobModelCopyWithImpl<$Res>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._self, this._then);

  final JobModel _self;
  final $Res Function(JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? jobDateTime = null,Object? jobEndDateTime = freezed,Object? description = null,Object? employerId = null,Object? responsibleId = null,Object? account = null,Object? transactionType = null,Object? registrationOpensAt = freezed,Object? sendNotification = null,Object? registrationDeadline = freezed,Object? cancellationDeadline = freezed,Object? cancellationAllowed = null,Object? registrationClosed = null,Object? maxParticipants = freezed,Object? waitlistEnabled = null,Object? minAge = freezed,Object? maxAge = freezed,Object? genderRestriction = freezed,Object? recurrence = freezed,Object? seriesId = freezed,Object? createDateTime = freezed,Object? createUserId = freezed,Object? createUserName = freezed,Object? employerName = freezed,Object? responsibleName = freezed,Object? status = null,Object? activityId = freezed,Object? completedDateTime = freezed,Object? registeredCount = null,Object? waitlistCount = null,Object? full = null,Object? registrationOpen = null,Object? cancellationOpen = null,Object? myRegistrationStatus = freezed,}) {
  return _then(JobModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,jobDateTime: null == jobDateTime ? _self.jobDateTime : jobDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,jobEndDateTime: freezed == jobEndDateTime ? _self.jobEndDateTime : jobEndDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,employerId: null == employerId ? _self.employerId : employerId // ignore: cast_nullable_to_non_nullable
as num,responsibleId: null == responsibleId ? _self.responsibleId : responsibleId // ignore: cast_nullable_to_non_nullable
as num,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as TransactionType,registrationOpensAt: freezed == registrationOpensAt ? _self.registrationOpensAt : registrationOpensAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sendNotification: null == sendNotification ? _self.sendNotification : sendNotification // ignore: cast_nullable_to_non_nullable
as bool,registrationDeadline: freezed == registrationDeadline ? _self.registrationDeadline : registrationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDeadline: freezed == cancellationDeadline ? _self.cancellationDeadline : cancellationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationAllowed: null == cancellationAllowed ? _self.cancellationAllowed : cancellationAllowed // ignore: cast_nullable_to_non_nullable
as bool,registrationClosed: null == registrationClosed ? _self.registrationClosed : registrationClosed // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,genderRestriction: freezed == genderRestriction ? _self.genderRestriction : genderRestriction // ignore: cast_nullable_to_non_nullable
as Gender?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as JobRecurrenceModel?,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,createDateTime: freezed == createDateTime ? _self.createDateTime : createDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createUserId: freezed == createUserId ? _self.createUserId : createUserId // ignore: cast_nullable_to_non_nullable
as num?,createUserName: freezed == createUserName ? _self.createUserName : createUserName // ignore: cast_nullable_to_non_nullable
as String?,employerName: freezed == employerName ? _self.employerName : employerName // ignore: cast_nullable_to_non_nullable
as String?,responsibleName: freezed == responsibleName ? _self.responsibleName : responsibleName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as num?,completedDateTime: freezed == completedDateTime ? _self.completedDateTime : completedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,registeredCount: null == registeredCount ? _self.registeredCount : registeredCount // ignore: cast_nullable_to_non_nullable
as num,waitlistCount: null == waitlistCount ? _self.waitlistCount : waitlistCount // ignore: cast_nullable_to_non_nullable
as num,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,registrationOpen: null == registrationOpen ? _self.registrationOpen : registrationOpen // ignore: cast_nullable_to_non_nullable
as bool,cancellationOpen: null == cancellationOpen ? _self.cancellationOpen : cancellationOpen // ignore: cast_nullable_to_non_nullable
as bool,myRegistrationStatus: freezed == myRegistrationStatus ? _self.myRegistrationStatus : myRegistrationStatus // ignore: cast_nullable_to_non_nullable
as JobRegistrationStatus?,
  ));
}
/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobRecurrenceModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $JobRecurrenceModelCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobModel].
extension JobModelPatterns on JobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobModel value)  $default,){
final _that = this;
switch (_that) {
case _JobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? id,  DateTime jobDateTime,  DateTime? jobEndDateTime,  String description,  num employerId,  num responsibleId,  Account account,  TransactionType transactionType,  DateTime? registrationOpensAt,  bool sendNotification,  DateTime? registrationDeadline,  DateTime? cancellationDeadline,  bool cancellationAllowed,  bool registrationClosed,  int? maxParticipants,  bool waitlistEnabled,  int? minAge,  int? maxAge, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Gender? genderRestriction, @JsonKey(includeIfNull: false)  JobRecurrenceModel? recurrence,  String? seriesId,  DateTime? createDateTime,  num? createUserId,  String? createUserName,  String? employerName,  String? responsibleName,  JobStatus status,  num? activityId,  DateTime? completedDateTime,  num registeredCount,  num waitlistCount,  bool full,  bool registrationOpen,  bool cancellationOpen,  JobRegistrationStatus? myRegistrationStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.id,_that.jobDateTime,_that.jobEndDateTime,_that.description,_that.employerId,_that.responsibleId,_that.account,_that.transactionType,_that.registrationOpensAt,_that.sendNotification,_that.registrationDeadline,_that.cancellationDeadline,_that.cancellationAllowed,_that.registrationClosed,_that.maxParticipants,_that.waitlistEnabled,_that.minAge,_that.maxAge,_that.genderRestriction,_that.recurrence,_that.seriesId,_that.createDateTime,_that.createUserId,_that.createUserName,_that.employerName,_that.responsibleName,_that.status,_that.activityId,_that.completedDateTime,_that.registeredCount,_that.waitlistCount,_that.full,_that.registrationOpen,_that.cancellationOpen,_that.myRegistrationStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? id,  DateTime jobDateTime,  DateTime? jobEndDateTime,  String description,  num employerId,  num responsibleId,  Account account,  TransactionType transactionType,  DateTime? registrationOpensAt,  bool sendNotification,  DateTime? registrationDeadline,  DateTime? cancellationDeadline,  bool cancellationAllowed,  bool registrationClosed,  int? maxParticipants,  bool waitlistEnabled,  int? minAge,  int? maxAge, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Gender? genderRestriction, @JsonKey(includeIfNull: false)  JobRecurrenceModel? recurrence,  String? seriesId,  DateTime? createDateTime,  num? createUserId,  String? createUserName,  String? employerName,  String? responsibleName,  JobStatus status,  num? activityId,  DateTime? completedDateTime,  num registeredCount,  num waitlistCount,  bool full,  bool registrationOpen,  bool cancellationOpen,  JobRegistrationStatus? myRegistrationStatus)  $default,) {final _that = this;
switch (_that) {
case _JobModel():
return $default(_that.id,_that.jobDateTime,_that.jobEndDateTime,_that.description,_that.employerId,_that.responsibleId,_that.account,_that.transactionType,_that.registrationOpensAt,_that.sendNotification,_that.registrationDeadline,_that.cancellationDeadline,_that.cancellationAllowed,_that.registrationClosed,_that.maxParticipants,_that.waitlistEnabled,_that.minAge,_that.maxAge,_that.genderRestriction,_that.recurrence,_that.seriesId,_that.createDateTime,_that.createUserId,_that.createUserName,_that.employerName,_that.responsibleName,_that.status,_that.activityId,_that.completedDateTime,_that.registeredCount,_that.waitlistCount,_that.full,_that.registrationOpen,_that.cancellationOpen,_that.myRegistrationStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? id,  DateTime jobDateTime,  DateTime? jobEndDateTime,  String description,  num employerId,  num responsibleId,  Account account,  TransactionType transactionType,  DateTime? registrationOpensAt,  bool sendNotification,  DateTime? registrationDeadline,  DateTime? cancellationDeadline,  bool cancellationAllowed,  bool registrationClosed,  int? maxParticipants,  bool waitlistEnabled,  int? minAge,  int? maxAge, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Gender? genderRestriction, @JsonKey(includeIfNull: false)  JobRecurrenceModel? recurrence,  String? seriesId,  DateTime? createDateTime,  num? createUserId,  String? createUserName,  String? employerName,  String? responsibleName,  JobStatus status,  num? activityId,  DateTime? completedDateTime,  num registeredCount,  num waitlistCount,  bool full,  bool registrationOpen,  bool cancellationOpen,  JobRegistrationStatus? myRegistrationStatus)?  $default,) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.id,_that.jobDateTime,_that.jobEndDateTime,_that.description,_that.employerId,_that.responsibleId,_that.account,_that.transactionType,_that.registrationOpensAt,_that.sendNotification,_that.registrationDeadline,_that.cancellationDeadline,_that.cancellationAllowed,_that.registrationClosed,_that.maxParticipants,_that.waitlistEnabled,_that.minAge,_that.maxAge,_that.genderRestriction,_that.recurrence,_that.seriesId,_that.createDateTime,_that.createUserId,_that.createUserName,_that.employerName,_that.responsibleName,_that.status,_that.activityId,_that.completedDateTime,_that.registeredCount,_that.waitlistCount,_that.full,_that.registrationOpen,_that.cancellationOpen,_that.myRegistrationStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobModel extends JobModel {
  const _JobModel({this.id, required this.jobDateTime, this.jobEndDateTime, required this.description, required this.employerId, required this.responsibleId, required this.account, required this.transactionType, this.registrationOpensAt, this.sendNotification = true, this.registrationDeadline, this.cancellationDeadline, this.cancellationAllowed = true, this.registrationClosed = false, this.maxParticipants, this.waitlistEnabled = false, this.minAge, this.maxAge, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.genderRestriction, @JsonKey(includeIfNull: false) this.recurrence, this.seriesId, this.createDateTime, this.createUserId, this.createUserName, this.employerName, this.responsibleName, this.status = JobStatus.OPEN, this.activityId, this.completedDateTime, this.registeredCount = 0, this.waitlistCount = 0, this.full = false, this.registrationOpen = false, this.cancellationOpen = false, this.myRegistrationStatus}): super._();
  factory _JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

@override final  num? id;
@override final  DateTime jobDateTime;
/// When the job ends; null for jobs created without an end time.
@override final  DateTime? jobEndDateTime;
@override final  String description;
@override final  num employerId;
@override final  num responsibleId;
@override final  Account account;
@override final  TransactionType transactionType;
/// Registration opens at this time; null means it is open from the start.
@override final  DateTime? registrationOpensAt;
/// Send a "new job" push when registration opens.
@override@JsonKey() final  bool sendNotification;
/// Last moment to register; null = no deadline.
@override final  DateTime? registrationDeadline;
/// Registered users can cancel on their own until then; null = no deadline.
@override final  DateTime? cancellationDeadline;
/// False: registered users can't cancel on their own at all.
@override@JsonKey() final  bool cancellationAllowed;
/// True: nobody can register until the job is opened again.
@override@JsonKey() final  bool registrationClosed;
/// Number of places; null for unlimited.
@override final  int? maxParticipants;
@override@JsonKey() final  bool waitlistEnabled;
@override final  int? minAge;
@override final  int? maxAge;
/// Null means open to everyone.
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  Gender? genderRestriction;
/// Only sent when creating: repeats the job on the given weekdays until a date.
@override@JsonKey(includeIfNull: false) final  JobRecurrenceModel? recurrence;
/// Shared by the occurrences of a repeating job; null for a single job.
@override final  String? seriesId;
@override final  DateTime? createDateTime;
@override final  num? createUserId;
@override final  String? createUserName;
@override final  String? employerName;
@override final  String? responsibleName;
@override@JsonKey() final  JobStatus status;
/// The activity created when the job was completed.
@override final  num? activityId;
@override final  DateTime? completedDateTime;
@override@JsonKey() final  num registeredCount;
@override@JsonKey() final  num waitlistCount;
@override@JsonKey() final  bool full;
/// Open for new registrations (or the waitlist) right now.
@override@JsonKey() final  bool registrationOpen;
/// Registered users can still cancel on their own.
@override@JsonKey() final  bool cancellationOpen;
/// The requesting user's own registration; null if none.
@override final  JobRegistrationStatus? myRegistrationStatus;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobModelCopyWith<_JobModel> get copyWith => __$JobModelCopyWithImpl<_JobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobModel&&(identical(other.id, id) || other.id == id)&&(identical(other.jobDateTime, jobDateTime) || other.jobDateTime == jobDateTime)&&(identical(other.jobEndDateTime, jobEndDateTime) || other.jobEndDateTime == jobEndDateTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.employerId, employerId) || other.employerId == employerId)&&(identical(other.responsibleId, responsibleId) || other.responsibleId == responsibleId)&&(identical(other.account, account) || other.account == account)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.registrationOpensAt, registrationOpensAt) || other.registrationOpensAt == registrationOpensAt)&&(identical(other.sendNotification, sendNotification) || other.sendNotification == sendNotification)&&(identical(other.registrationDeadline, registrationDeadline) || other.registrationDeadline == registrationDeadline)&&(identical(other.cancellationDeadline, cancellationDeadline) || other.cancellationDeadline == cancellationDeadline)&&(identical(other.cancellationAllowed, cancellationAllowed) || other.cancellationAllowed == cancellationAllowed)&&(identical(other.registrationClosed, registrationClosed) || other.registrationClosed == registrationClosed)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.waitlistEnabled, waitlistEnabled) || other.waitlistEnabled == waitlistEnabled)&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.genderRestriction, genderRestriction) || other.genderRestriction == genderRestriction)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.createDateTime, createDateTime) || other.createDateTime == createDateTime)&&(identical(other.createUserId, createUserId) || other.createUserId == createUserId)&&(identical(other.createUserName, createUserName) || other.createUserName == createUserName)&&(identical(other.employerName, employerName) || other.employerName == employerName)&&(identical(other.responsibleName, responsibleName) || other.responsibleName == responsibleName)&&(identical(other.status, status) || other.status == status)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.completedDateTime, completedDateTime) || other.completedDateTime == completedDateTime)&&(identical(other.registeredCount, registeredCount) || other.registeredCount == registeredCount)&&(identical(other.waitlistCount, waitlistCount) || other.waitlistCount == waitlistCount)&&(identical(other.full, full) || other.full == full)&&(identical(other.registrationOpen, registrationOpen) || other.registrationOpen == registrationOpen)&&(identical(other.cancellationOpen, cancellationOpen) || other.cancellationOpen == cancellationOpen)&&(identical(other.myRegistrationStatus, myRegistrationStatus) || other.myRegistrationStatus == myRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,jobDateTime,jobEndDateTime,description,employerId,responsibleId,account,transactionType,registrationOpensAt,sendNotification,registrationDeadline,cancellationDeadline,cancellationAllowed,registrationClosed,maxParticipants,waitlistEnabled,minAge,maxAge,genderRestriction,recurrence,seriesId,createDateTime,createUserId,createUserName,employerName,responsibleName,status,activityId,completedDateTime,registeredCount,waitlistCount,full,registrationOpen,cancellationOpen,myRegistrationStatus]);
}

@override
String toString() {
    return 'JobModel(id: $id, jobDateTime: $jobDateTime, jobEndDateTime: $jobEndDateTime, description: $description, employerId: $employerId, responsibleId: $responsibleId, account: $account, transactionType: $transactionType, registrationOpensAt: $registrationOpensAt, sendNotification: $sendNotification, registrationDeadline: $registrationDeadline, cancellationDeadline: $cancellationDeadline, cancellationAllowed: $cancellationAllowed, registrationClosed: $registrationClosed, maxParticipants: $maxParticipants, waitlistEnabled: $waitlistEnabled, minAge: $minAge, maxAge: $maxAge, genderRestriction: $genderRestriction, recurrence: $recurrence, seriesId: $seriesId, createDateTime: $createDateTime, createUserId: $createUserId, createUserName: $createUserName, employerName: $employerName, responsibleName: $responsibleName, status: $status, activityId: $activityId, completedDateTime: $completedDateTime, registeredCount: $registeredCount, waitlistCount: $waitlistCount, full: $full, registrationOpen: $registrationOpen, cancellationOpen: $cancellationOpen, myRegistrationStatus: $myRegistrationStatus)';
}


}

/// @nodoc
abstract mixin class _$JobModelCopyWith<$Res> implements $JobModelCopyWith<$Res> {
  factory _$JobModelCopyWith(_JobModel value, $Res Function(_JobModel) _then) = __$JobModelCopyWithImpl;
@override @useResult
$Res call({
 num? id, DateTime jobDateTime, DateTime? jobEndDateTime, String description, num employerId, num responsibleId, Account account, TransactionType transactionType, DateTime? registrationOpensAt, bool sendNotification, DateTime? registrationDeadline, DateTime? cancellationDeadline, bool cancellationAllowed, bool registrationClosed, int? maxParticipants, bool waitlistEnabled, int? minAge, int? maxAge,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? genderRestriction,@JsonKey(includeIfNull: false) JobRecurrenceModel? recurrence, String? seriesId, DateTime? createDateTime, num? createUserId, String? createUserName, String? employerName, String? responsibleName, JobStatus status, num? activityId, DateTime? completedDateTime, num registeredCount, num waitlistCount, bool full, bool registrationOpen, bool cancellationOpen, JobRegistrationStatus? myRegistrationStatus
});


@override $JobRecurrenceModelCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$JobModelCopyWithImpl<$Res>
    implements _$JobModelCopyWith<$Res> {
  __$JobModelCopyWithImpl(this._self, this._then);

  final _JobModel _self;
  final $Res Function(_JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? jobDateTime = null,Object? jobEndDateTime = freezed,Object? description = null,Object? employerId = null,Object? responsibleId = null,Object? account = null,Object? transactionType = null,Object? registrationOpensAt = freezed,Object? sendNotification = null,Object? registrationDeadline = freezed,Object? cancellationDeadline = freezed,Object? cancellationAllowed = null,Object? registrationClosed = null,Object? maxParticipants = freezed,Object? waitlistEnabled = null,Object? minAge = freezed,Object? maxAge = freezed,Object? genderRestriction = freezed,Object? recurrence = freezed,Object? seriesId = freezed,Object? createDateTime = freezed,Object? createUserId = freezed,Object? createUserName = freezed,Object? employerName = freezed,Object? responsibleName = freezed,Object? status = null,Object? activityId = freezed,Object? completedDateTime = freezed,Object? registeredCount = null,Object? waitlistCount = null,Object? full = null,Object? registrationOpen = null,Object? cancellationOpen = null,Object? myRegistrationStatus = freezed,}) {
  return _then(_JobModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num?,jobDateTime: null == jobDateTime ? _self.jobDateTime : jobDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,jobEndDateTime: freezed == jobEndDateTime ? _self.jobEndDateTime : jobEndDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,employerId: null == employerId ? _self.employerId : employerId // ignore: cast_nullable_to_non_nullable
as num,responsibleId: null == responsibleId ? _self.responsibleId : responsibleId // ignore: cast_nullable_to_non_nullable
as num,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as TransactionType,registrationOpensAt: freezed == registrationOpensAt ? _self.registrationOpensAt : registrationOpensAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sendNotification: null == sendNotification ? _self.sendNotification : sendNotification // ignore: cast_nullable_to_non_nullable
as bool,registrationDeadline: freezed == registrationDeadline ? _self.registrationDeadline : registrationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDeadline: freezed == cancellationDeadline ? _self.cancellationDeadline : cancellationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationAllowed: null == cancellationAllowed ? _self.cancellationAllowed : cancellationAllowed // ignore: cast_nullable_to_non_nullable
as bool,registrationClosed: null == registrationClosed ? _self.registrationClosed : registrationClosed // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,genderRestriction: freezed == genderRestriction ? _self.genderRestriction : genderRestriction // ignore: cast_nullable_to_non_nullable
as Gender?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as JobRecurrenceModel?,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,createDateTime: freezed == createDateTime ? _self.createDateTime : createDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createUserId: freezed == createUserId ? _self.createUserId : createUserId // ignore: cast_nullable_to_non_nullable
as num?,createUserName: freezed == createUserName ? _self.createUserName : createUserName // ignore: cast_nullable_to_non_nullable
as String?,employerName: freezed == employerName ? _self.employerName : employerName // ignore: cast_nullable_to_non_nullable
as String?,responsibleName: freezed == responsibleName ? _self.responsibleName : responsibleName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as num?,completedDateTime: freezed == completedDateTime ? _self.completedDateTime : completedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,registeredCount: null == registeredCount ? _self.registeredCount : registeredCount // ignore: cast_nullable_to_non_nullable
as num,waitlistCount: null == waitlistCount ? _self.waitlistCount : waitlistCount // ignore: cast_nullable_to_non_nullable
as num,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,registrationOpen: null == registrationOpen ? _self.registrationOpen : registrationOpen // ignore: cast_nullable_to_non_nullable
as bool,cancellationOpen: null == cancellationOpen ? _self.cancellationOpen : cancellationOpen // ignore: cast_nullable_to_non_nullable
as bool,myRegistrationStatus: freezed == myRegistrationStatus ? _self.myRegistrationStatus : myRegistrationStatus // ignore: cast_nullable_to_non_nullable
as JobRegistrationStatus?,
  ));
}

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobRecurrenceModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $JobRecurrenceModelCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}

// dart format on
