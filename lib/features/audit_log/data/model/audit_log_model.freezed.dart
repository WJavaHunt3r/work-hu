// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogModel {

 num get id; DateTime get timestamp;/// CREATE, UPDATE, DELETE, LOGIN, ...; a string so actions added to the backend don't break parsing.
 String get action; String? get entityType; String? get entityId; num? get userId; String? get username; String? get ipAddress;/// The request that caused the entry, e.g. "PUT /api/user/12".
 String? get request;/// A JSON object (changed fields with old and new values, login method, ...), a plain string, or null.
 dynamic get details;
/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogModelCopyWith<AuditLogModel> get copyWith => _$AuditLogModelCopyWithImpl<AuditLogModel>(this as AuditLogModel, _$identity);

  /// Serializes this AuditLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuditLogModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.entityType, _this.entityType) || other.entityType == _this.entityType)&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.ipAddress, _this.ipAddress) || other.ipAddress == _this.ipAddress)&&(identical(other.request, _this.request) || other.request == _this.request)&&const DeepCollectionEquality().equals(other.details, _this.details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditLogModel;
  return Object.hash(runtimeType,_this.id,_this.timestamp,_this.action,_this.entityType,_this.entityId,_this.userId,_this.username,_this.ipAddress,_this.request,const DeepCollectionEquality().hash(_this.details));
}

@override
String toString() {
  final _this = this as AuditLogModel;
  return 'AuditLogModel(id: ${_this.id}, timestamp: ${_this.timestamp}, action: ${_this.action}, entityType: ${_this.entityType}, entityId: ${_this.entityId}, userId: ${_this.userId}, username: ${_this.username}, ipAddress: ${_this.ipAddress}, request: ${_this.request}, details: ${_this.details})';
}


}

/// @nodoc
abstract mixin class $AuditLogModelCopyWith<$Res>  {
  factory $AuditLogModelCopyWith(AuditLogModel value, $Res Function(AuditLogModel) _then) = _$AuditLogModelCopyWithImpl;
@useResult
$Res call({
 num id, DateTime timestamp, String action, String? entityType, String? entityId, num? userId, String? username, String? ipAddress, String? request, dynamic details
});




}
/// @nodoc
class _$AuditLogModelCopyWithImpl<$Res>
    implements $AuditLogModelCopyWith<$Res> {
  _$AuditLogModelCopyWithImpl(this._self, this._then);

  final AuditLogModel _self;
  final $Res Function(AuditLogModel) _then;

/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? action = null,Object? entityType = freezed,Object? entityId = freezed,Object? userId = freezed,Object? username = freezed,Object? ipAddress = freezed,Object? request = freezed,Object? details = freezed,}) {
  return _then(AuditLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as num?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogModel].
extension AuditLogModelPatterns on AuditLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogModel value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num id,  DateTime timestamp,  String action,  String? entityType,  String? entityId,  num? userId,  String? username,  String? ipAddress,  String? request,  dynamic details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
return $default(_that.id,_that.timestamp,_that.action,_that.entityType,_that.entityId,_that.userId,_that.username,_that.ipAddress,_that.request,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num id,  DateTime timestamp,  String action,  String? entityType,  String? entityId,  num? userId,  String? username,  String? ipAddress,  String? request,  dynamic details)  $default,) {final _that = this;
switch (_that) {
case _AuditLogModel():
return $default(_that.id,_that.timestamp,_that.action,_that.entityType,_that.entityId,_that.userId,_that.username,_that.ipAddress,_that.request,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num id,  DateTime timestamp,  String action,  String? entityType,  String? entityId,  num? userId,  String? username,  String? ipAddress,  String? request,  dynamic details)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogModel() when $default != null:
return $default(_that.id,_that.timestamp,_that.action,_that.entityType,_that.entityId,_that.userId,_that.username,_that.ipAddress,_that.request,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogModel implements AuditLogModel {
  const _AuditLogModel({required this.id, required this.timestamp, required this.action, this.entityType, this.entityId, this.userId, this.username, this.ipAddress, this.request, this.details});
  factory _AuditLogModel.fromJson(Map<String, dynamic> json) => _$AuditLogModelFromJson(json);

@override final  num id;
@override final  DateTime timestamp;
/// CREATE, UPDATE, DELETE, LOGIN, ...; a string so actions added to the backend don't break parsing.
@override final  String action;
@override final  String? entityType;
@override final  String? entityId;
@override final  num? userId;
@override final  String? username;
@override final  String? ipAddress;
/// The request that caused the entry, e.g. "PUT /api/user/12".
@override final  String? request;
/// A JSON object (changed fields with old and new values, login method, ...), a plain string, or null.
@override final  dynamic details;

/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogModelCopyWith<_AuditLogModel> get copyWith => __$AuditLogModelCopyWithImpl<_AuditLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.request, request) || other.request == request)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,timestamp,action,entityType,entityId,userId,username,ipAddress,request,const DeepCollectionEquality().hash(details));
}

@override
String toString() {
    return 'AuditLogModel(id: $id, timestamp: $timestamp, action: $action, entityType: $entityType, entityId: $entityId, userId: $userId, username: $username, ipAddress: $ipAddress, request: $request, details: $details)';
}


}

/// @nodoc
abstract mixin class _$AuditLogModelCopyWith<$Res> implements $AuditLogModelCopyWith<$Res> {
  factory _$AuditLogModelCopyWith(_AuditLogModel value, $Res Function(_AuditLogModel) _then) = __$AuditLogModelCopyWithImpl;
@override @useResult
$Res call({
 num id, DateTime timestamp, String action, String? entityType, String? entityId, num? userId, String? username, String? ipAddress, String? request, dynamic details
});




}
/// @nodoc
class __$AuditLogModelCopyWithImpl<$Res>
    implements _$AuditLogModelCopyWith<$Res> {
  __$AuditLogModelCopyWithImpl(this._self, this._then);

  final _AuditLogModel _self;
  final $Res Function(_AuditLogModel) _then;

/// Create a copy of AuditLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? action = null,Object? entityType = freezed,Object? entityId = freezed,Object? userId = freezed,Object? username = freezed,Object? ipAddress = freezed,Object? request = freezed,Object? details = freezed,}) {
  return _then(_AuditLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as num?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
