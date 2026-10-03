// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogFilter {

 String? get action; String? get entityType; String? get username; DateTime? get dateFrom;/// Inclusive.
 DateTime? get dateTo;/// Matches the details and the request path.
 String? get searchText;
/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogFilterCopyWith<AuditLogFilter> get copyWith => _$AuditLogFilterCopyWithImpl<AuditLogFilter>(this as AuditLogFilter, _$identity);

  /// Serializes this AuditLogFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuditLogFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogFilter&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.entityType, _this.entityType) || other.entityType == _this.entityType)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.dateFrom, _this.dateFrom) || other.dateFrom == _this.dateFrom)&&(identical(other.dateTo, _this.dateTo) || other.dateTo == _this.dateTo)&&(identical(other.searchText, _this.searchText) || other.searchText == _this.searchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditLogFilter;
  return Object.hash(runtimeType,_this.action,_this.entityType,_this.username,_this.dateFrom,_this.dateTo,_this.searchText);
}

@override
String toString() {
  final _this = this as AuditLogFilter;
  return 'AuditLogFilter(action: ${_this.action}, entityType: ${_this.entityType}, username: ${_this.username}, dateFrom: ${_this.dateFrom}, dateTo: ${_this.dateTo}, searchText: ${_this.searchText})';
}


}

/// @nodoc
abstract mixin class $AuditLogFilterCopyWith<$Res>  {
  factory $AuditLogFilterCopyWith(AuditLogFilter value, $Res Function(AuditLogFilter) _then) = _$AuditLogFilterCopyWithImpl;
@useResult
$Res call({
 String? action, String? entityType, String? username, DateTime? dateFrom, DateTime? dateTo, String? searchText
});




}
/// @nodoc
class _$AuditLogFilterCopyWithImpl<$Res>
    implements $AuditLogFilterCopyWith<$Res> {
  _$AuditLogFilterCopyWithImpl(this._self, this._then);

  final AuditLogFilter _self;
  final $Res Function(AuditLogFilter) _then;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? entityType = freezed,Object? username = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? searchText = freezed,}) {
  return _then(AuditLogFilter(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogFilter].
extension AuditLogFilterPatterns on AuditLogFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogFilter value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? entityType,  String? username,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
return $default(_that.action,_that.entityType,_that.username,_that.dateFrom,_that.dateTo,_that.searchText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? entityType,  String? username,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)  $default,) {final _that = this;
switch (_that) {
case _AuditLogFilter():
return $default(_that.action,_that.entityType,_that.username,_that.dateFrom,_that.dateTo,_that.searchText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? entityType,  String? username,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogFilter() when $default != null:
return $default(_that.action,_that.entityType,_that.username,_that.dateFrom,_that.dateTo,_that.searchText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogFilter implements AuditLogFilter {
  const _AuditLogFilter({this.action, this.entityType, this.username, this.dateFrom, this.dateTo, this.searchText});
  factory _AuditLogFilter.fromJson(Map<String, dynamic> json) => _$AuditLogFilterFromJson(json);

@override final  String? action;
@override final  String? entityType;
@override final  String? username;
@override final  DateTime? dateFrom;
/// Inclusive.
@override final  DateTime? dateTo;
/// Matches the details and the request path.
@override final  String? searchText;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogFilterCopyWith<_AuditLogFilter> get copyWith => __$AuditLogFilterCopyWithImpl<_AuditLogFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogFilterToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogFilter&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.username, username) || other.username == username)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.searchText, searchText) || other.searchText == searchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,action,entityType,username,dateFrom,dateTo,searchText);
}

@override
String toString() {
    return 'AuditLogFilter(action: $action, entityType: $entityType, username: $username, dateFrom: $dateFrom, dateTo: $dateTo, searchText: $searchText)';
}


}

/// @nodoc
abstract mixin class _$AuditLogFilterCopyWith<$Res> implements $AuditLogFilterCopyWith<$Res> {
  factory _$AuditLogFilterCopyWith(_AuditLogFilter value, $Res Function(_AuditLogFilter) _then) = __$AuditLogFilterCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? entityType, String? username, DateTime? dateFrom, DateTime? dateTo, String? searchText
});




}
/// @nodoc
class __$AuditLogFilterCopyWithImpl<$Res>
    implements _$AuditLogFilterCopyWith<$Res> {
  __$AuditLogFilterCopyWithImpl(this._self, this._then);

  final _AuditLogFilter _self;
  final $Res Function(_AuditLogFilter) _then;

/// Create a copy of AuditLogFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? entityType = freezed,Object? username = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? searchText = freezed,}) {
  return _then(_AuditLogFilter(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
