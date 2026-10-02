// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobDetailState {

 JobModel? get job;/// Active registrations (registered and waitlisted) in registration order.
 List<JobRegistrationModel> get registrations;/// The current user's children, who they may register and cancel.
 List<UserModel> get children; BaseState get status;
/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobDetailStateCopyWith<JobDetailState> get copyWith => _$JobDetailStateCopyWithImpl<JobDetailState>(this as JobDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JobDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobDetailState&&(identical(other.job, _this.job) || other.job == _this.job)&&const DeepCollectionEquality().equals(other.registrations, _this.registrations)&&const DeepCollectionEquality().equals(other.children, _this.children)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as JobDetailState;
  return Object.hash(runtimeType,_this.job,const DeepCollectionEquality().hash(_this.registrations),const DeepCollectionEquality().hash(_this.children),_this.status);
}

@override
String toString() {
  final _this = this as JobDetailState;
  return 'JobDetailState(job: ${_this.job}, registrations: ${_this.registrations}, children: ${_this.children}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $JobDetailStateCopyWith<$Res>  {
  factory $JobDetailStateCopyWith(JobDetailState value, $Res Function(JobDetailState) _then) = _$JobDetailStateCopyWithImpl;
@useResult
$Res call({
 JobModel? job, List<JobRegistrationModel> registrations, List<UserModel> children, BaseState status
});


$JobModelCopyWith<$Res>? get job;$BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class _$JobDetailStateCopyWithImpl<$Res>
    implements $JobDetailStateCopyWith<$Res> {
  _$JobDetailStateCopyWithImpl(this._self, this._then);

  final JobDetailState _self;
  final $Res Function(JobDetailState) _then;

/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = freezed,Object? registrations = null,Object? children = null,Object? status = null,}) {
  return _then(JobDetailState(
job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel?,registrations: null == registrations ? _self.registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<JobRegistrationModel>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<UserModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,
  ));
}
/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $JobModelCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStateCopyWith<$Res> get status {
  
  return $BaseStateCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobDetailState].
extension JobDetailStatePatterns on JobDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobDetailState value)  $default,){
final _that = this;
switch (_that) {
case _JobDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _JobDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobModel? job,  List<JobRegistrationModel> registrations,  List<UserModel> children,  BaseState status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobDetailState() when $default != null:
return $default(_that.job,_that.registrations,_that.children,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobModel? job,  List<JobRegistrationModel> registrations,  List<UserModel> children,  BaseState status)  $default,) {final _that = this;
switch (_that) {
case _JobDetailState():
return $default(_that.job,_that.registrations,_that.children,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobModel? job,  List<JobRegistrationModel> registrations,  List<UserModel> children,  BaseState status)?  $default,) {final _that = this;
switch (_that) {
case _JobDetailState() when $default != null:
return $default(_that.job,_that.registrations,_that.children,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _JobDetailState extends JobDetailState {
  const _JobDetailState({this.job,  List<JobRegistrationModel> registrations = const [],  List<UserModel> children = const [], this.status = const BaseState()}): _registrations = registrations,_children = children,super._();
  

@override final  JobModel? job;
/// Active registrations (registered and waitlisted) in registration order.
 final  List<JobRegistrationModel> _registrations;
/// Active registrations (registered and waitlisted) in registration order.
@override@JsonKey() List<JobRegistrationModel> get registrations {
  if (_registrations is EqualUnmodifiableListView) return _registrations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registrations);
}

/// The current user's children, who they may register and cancel.
 final  List<UserModel> _children;
/// The current user's children, who they may register and cancel.
@override@JsonKey() List<UserModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override@JsonKey() final  BaseState status;

/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobDetailStateCopyWith<_JobDetailState> get copyWith => __$JobDetailStateCopyWithImpl<_JobDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobDetailState&&(identical(other.job, job) || other.job == job)&&const DeepCollectionEquality().equals(other.registrations, _registrations)&&const DeepCollectionEquality().equals(other.children, _children)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,job,const DeepCollectionEquality().hash(_registrations),const DeepCollectionEquality().hash(_children),status);
}

@override
String toString() {
    return 'JobDetailState(job: $job, registrations: $registrations, children: $children, status: $status)';
}


}

/// @nodoc
abstract mixin class _$JobDetailStateCopyWith<$Res> implements $JobDetailStateCopyWith<$Res> {
  factory _$JobDetailStateCopyWith(_JobDetailState value, $Res Function(_JobDetailState) _then) = __$JobDetailStateCopyWithImpl;
@override @useResult
$Res call({
 JobModel? job, List<JobRegistrationModel> registrations, List<UserModel> children, BaseState status
});


@override $JobModelCopyWith<$Res>? get job;@override $BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class __$JobDetailStateCopyWithImpl<$Res>
    implements _$JobDetailStateCopyWith<$Res> {
  __$JobDetailStateCopyWithImpl(this._self, this._then);

  final _JobDetailState _self;
  final $Res Function(_JobDetailState) _then;

/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = freezed,Object? registrations = null,Object? children = null,Object? status = null,}) {
  return _then(_JobDetailState(
job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel?,registrations: null == registrations ? _self._registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<JobRegistrationModel>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<UserModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,
  ));
}

/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $JobModelCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}/// Create a copy of JobDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStateCopyWith<$Res> get status {
  
  return $BaseStateCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

// dart format on
