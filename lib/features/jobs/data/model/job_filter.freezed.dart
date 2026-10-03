// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobFilter {

 JobStatus? get status;/// Only jobs that accept registrations right now.
 bool get openOnly;/// Only jobs the current user is registered for.
 bool get onlyMine; DateTime? get dateFrom; DateTime? get dateTo; String? get searchText;
/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobFilterCopyWith<JobFilter> get copyWith => _$JobFilterCopyWithImpl<JobFilter>(this as JobFilter, _$identity);

  /// Serializes this JobFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobFilter&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.openOnly, _this.openOnly) || other.openOnly == _this.openOnly)&&(identical(other.onlyMine, _this.onlyMine) || other.onlyMine == _this.onlyMine)&&(identical(other.dateFrom, _this.dateFrom) || other.dateFrom == _this.dateFrom)&&(identical(other.dateTo, _this.dateTo) || other.dateTo == _this.dateTo)&&(identical(other.searchText, _this.searchText) || other.searchText == _this.searchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobFilter;
  return Object.hash(runtimeType,_this.status,_this.openOnly,_this.onlyMine,_this.dateFrom,_this.dateTo,_this.searchText);
}

@override
String toString() {
  final _this = this as JobFilter;
  return 'JobFilter(status: ${_this.status}, openOnly: ${_this.openOnly}, onlyMine: ${_this.onlyMine}, dateFrom: ${_this.dateFrom}, dateTo: ${_this.dateTo}, searchText: ${_this.searchText})';
}


}

/// @nodoc
abstract mixin class $JobFilterCopyWith<$Res>  {
  factory $JobFilterCopyWith(JobFilter value, $Res Function(JobFilter) _then) = _$JobFilterCopyWithImpl;
@useResult
$Res call({
 JobStatus? status, bool openOnly, bool onlyMine, DateTime? dateFrom, DateTime? dateTo, String? searchText
});




}
/// @nodoc
class _$JobFilterCopyWithImpl<$Res>
    implements $JobFilterCopyWith<$Res> {
  _$JobFilterCopyWithImpl(this._self, this._then);

  final JobFilter _self;
  final $Res Function(JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? openOnly = null,Object? onlyMine = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? searchText = freezed,}) {
  return _then(JobFilter(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus?,openOnly: null == openOnly ? _self.openOnly : openOnly // ignore: cast_nullable_to_non_nullable
as bool,onlyMine: null == onlyMine ? _self.onlyMine : onlyMine // ignore: cast_nullable_to_non_nullable
as bool,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobFilter].
extension JobFilterPatterns on JobFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobFilter value)  $default,){
final _that = this;
switch (_that) {
case _JobFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobFilter value)?  $default,){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobStatus? status,  bool openOnly,  bool onlyMine,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.status,_that.openOnly,_that.onlyMine,_that.dateFrom,_that.dateTo,_that.searchText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobStatus? status,  bool openOnly,  bool onlyMine,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)  $default,) {final _that = this;
switch (_that) {
case _JobFilter():
return $default(_that.status,_that.openOnly,_that.onlyMine,_that.dateFrom,_that.dateTo,_that.searchText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobStatus? status,  bool openOnly,  bool onlyMine,  DateTime? dateFrom,  DateTime? dateTo,  String? searchText)?  $default,) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.status,_that.openOnly,_that.onlyMine,_that.dateFrom,_that.dateTo,_that.searchText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobFilter implements JobFilter {
  const _JobFilter({this.status, this.openOnly = false, this.onlyMine = false, this.dateFrom, this.dateTo, this.searchText});
  factory _JobFilter.fromJson(Map<String, dynamic> json) => _$JobFilterFromJson(json);

@override final  JobStatus? status;
/// Only jobs that accept registrations right now.
@override@JsonKey() final  bool openOnly;
/// Only jobs the current user is registered for.
@override@JsonKey() final  bool onlyMine;
@override final  DateTime? dateFrom;
@override final  DateTime? dateTo;
@override final  String? searchText;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobFilterCopyWith<_JobFilter> get copyWith => __$JobFilterCopyWithImpl<_JobFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobFilterToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.openOnly, openOnly) || other.openOnly == openOnly)&&(identical(other.onlyMine, onlyMine) || other.onlyMine == onlyMine)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.searchText, searchText) || other.searchText == searchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,openOnly,onlyMine,dateFrom,dateTo,searchText);
}

@override
String toString() {
    return 'JobFilter(status: $status, openOnly: $openOnly, onlyMine: $onlyMine, dateFrom: $dateFrom, dateTo: $dateTo, searchText: $searchText)';
}


}

/// @nodoc
abstract mixin class _$JobFilterCopyWith<$Res> implements $JobFilterCopyWith<$Res> {
  factory _$JobFilterCopyWith(_JobFilter value, $Res Function(_JobFilter) _then) = __$JobFilterCopyWithImpl;
@override @useResult
$Res call({
 JobStatus? status, bool openOnly, bool onlyMine, DateTime? dateFrom, DateTime? dateTo, String? searchText
});




}
/// @nodoc
class __$JobFilterCopyWithImpl<$Res>
    implements _$JobFilterCopyWith<$Res> {
  __$JobFilterCopyWithImpl(this._self, this._then);

  final _JobFilter _self;
  final $Res Function(_JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? openOnly = null,Object? onlyMine = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? searchText = freezed,}) {
  return _then(_JobFilter(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus?,openOnly: null == openOnly ? _self.openOnly : openOnly // ignore: cast_nullable_to_non_nullable
as bool,onlyMine: null == onlyMine ? _self.onlyMine : onlyMine // ignore: cast_nullable_to_non_nullable
as bool,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
