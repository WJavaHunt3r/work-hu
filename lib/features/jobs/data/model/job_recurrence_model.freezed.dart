// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_recurrence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobRecurrenceModel {

 List<String> get daysOfWeek;@JsonKey(toJson: _dateOnly) DateTime get repeatUntil;
/// Create a copy of JobRecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRecurrenceModelCopyWith<JobRecurrenceModel> get copyWith => _$JobRecurrenceModelCopyWithImpl<JobRecurrenceModel>(this as JobRecurrenceModel, _$identity);

  /// Serializes this JobRecurrenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobRecurrenceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRecurrenceModel&&const DeepCollectionEquality().equals(other.daysOfWeek, _this.daysOfWeek)&&(identical(other.repeatUntil, _this.repeatUntil) || other.repeatUntil == _this.repeatUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobRecurrenceModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.daysOfWeek),_this.repeatUntil);
}

@override
String toString() {
  final _this = this as JobRecurrenceModel;
  return 'JobRecurrenceModel(daysOfWeek: ${_this.daysOfWeek}, repeatUntil: ${_this.repeatUntil})';
}


}

/// @nodoc
abstract mixin class $JobRecurrenceModelCopyWith<$Res>  {
  factory $JobRecurrenceModelCopyWith(JobRecurrenceModel value, $Res Function(JobRecurrenceModel) _then) = _$JobRecurrenceModelCopyWithImpl;
@useResult
$Res call({
 List<String> daysOfWeek,@JsonKey(toJson: _dateOnly) DateTime repeatUntil
});




}
/// @nodoc
class _$JobRecurrenceModelCopyWithImpl<$Res>
    implements $JobRecurrenceModelCopyWith<$Res> {
  _$JobRecurrenceModelCopyWithImpl(this._self, this._then);

  final JobRecurrenceModel _self;
  final $Res Function(JobRecurrenceModel) _then;

/// Create a copy of JobRecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daysOfWeek = null,Object? repeatUntil = null,}) {
  return _then(JobRecurrenceModel(
daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<String>,repeatUntil: null == repeatUntil ? _self.repeatUntil : repeatUntil // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobRecurrenceModel].
extension JobRecurrenceModelPatterns on JobRecurrenceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobRecurrenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobRecurrenceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobRecurrenceModel value)  $default,){
final _that = this;
switch (_that) {
case _JobRecurrenceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobRecurrenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobRecurrenceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> daysOfWeek, @JsonKey(toJson: _dateOnly)  DateTime repeatUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobRecurrenceModel() when $default != null:
return $default(_that.daysOfWeek,_that.repeatUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> daysOfWeek, @JsonKey(toJson: _dateOnly)  DateTime repeatUntil)  $default,) {final _that = this;
switch (_that) {
case _JobRecurrenceModel():
return $default(_that.daysOfWeek,_that.repeatUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> daysOfWeek, @JsonKey(toJson: _dateOnly)  DateTime repeatUntil)?  $default,) {final _that = this;
switch (_that) {
case _JobRecurrenceModel() when $default != null:
return $default(_that.daysOfWeek,_that.repeatUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobRecurrenceModel implements JobRecurrenceModel {
  const _JobRecurrenceModel({ List<String> daysOfWeek = const [], @JsonKey(toJson: _dateOnly) required this.repeatUntil}): _daysOfWeek = daysOfWeek;
  factory _JobRecurrenceModel.fromJson(Map<String, dynamic> json) => _$JobRecurrenceModelFromJson(json);

 final  List<String> _daysOfWeek;
@override@JsonKey() List<String> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfWeek);
}

@override@JsonKey(toJson: _dateOnly) final  DateTime repeatUntil;

/// Create a copy of JobRecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobRecurrenceModelCopyWith<_JobRecurrenceModel> get copyWith => __$JobRecurrenceModelCopyWithImpl<_JobRecurrenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobRecurrenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobRecurrenceModel&&const DeepCollectionEquality().equals(other.daysOfWeek, _daysOfWeek)&&(identical(other.repeatUntil, repeatUntil) || other.repeatUntil == repeatUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_daysOfWeek),repeatUntil);
}

@override
String toString() {
    return 'JobRecurrenceModel(daysOfWeek: $daysOfWeek, repeatUntil: $repeatUntil)';
}


}

/// @nodoc
abstract mixin class _$JobRecurrenceModelCopyWith<$Res> implements $JobRecurrenceModelCopyWith<$Res> {
  factory _$JobRecurrenceModelCopyWith(_JobRecurrenceModel value, $Res Function(_JobRecurrenceModel) _then) = __$JobRecurrenceModelCopyWithImpl;
@override @useResult
$Res call({
 List<String> daysOfWeek,@JsonKey(toJson: _dateOnly) DateTime repeatUntil
});




}
/// @nodoc
class __$JobRecurrenceModelCopyWithImpl<$Res>
    implements _$JobRecurrenceModelCopyWith<$Res> {
  __$JobRecurrenceModelCopyWithImpl(this._self, this._then);

  final _JobRecurrenceModel _self;
  final $Res Function(_JobRecurrenceModel) _then;

/// Create a copy of JobRecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? daysOfWeek = null,Object? repeatUntil = null,}) {
  return _then(_JobRecurrenceModel(
daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<String>,repeatUntil: null == repeatUntil ? _self.repeatUntil : repeatUntil // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
