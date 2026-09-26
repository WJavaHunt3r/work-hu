// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 List<UserModel> get children; List<UserStatusModel> get statuses; List<UserRoundModel> get userRounds; BaseState get status;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&const DeepCollectionEquality().equals(other.children, _this.children)&&const DeepCollectionEquality().equals(other.statuses, _this.statuses)&&const DeepCollectionEquality().equals(other.userRounds, _this.userRounds)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as ProfileState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.children),const DeepCollectionEquality().hash(_this.statuses),const DeepCollectionEquality().hash(_this.userRounds),_this.status);
}

@override
String toString() {
  final _this = this as ProfileState;
  return 'ProfileState(children: ${_this.children}, statuses: ${_this.statuses}, userRounds: ${_this.userRounds}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 List<UserModel> children, List<UserStatusModel> statuses, List<UserRoundModel> userRounds, BaseState status
});


$BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? children = null,Object? statuses = null,Object? userRounds = null,Object? status = null,}) {
  return _then(ProfileState(
children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<UserModel>,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<UserStatusModel>,userRounds: null == userRounds ? _self.userRounds : userRounds // ignore: cast_nullable_to_non_nullable
as List<UserRoundModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStateCopyWith<$Res> get status {
  
  return $BaseStateCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserModel> children,  List<UserStatusModel> statuses,  List<UserRoundModel> userRounds,  BaseState status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.children,_that.statuses,_that.userRounds,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserModel> children,  List<UserStatusModel> statuses,  List<UserRoundModel> userRounds,  BaseState status)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.children,_that.statuses,_that.userRounds,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserModel> children,  List<UserStatusModel> statuses,  List<UserRoundModel> userRounds,  BaseState status)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.children,_that.statuses,_that.userRounds,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState extends ProfileState {
  const _ProfileState({ List<UserModel> children = const [],  List<UserStatusModel> statuses = const [],  List<UserRoundModel> userRounds = const [], this.status = const BaseState()}): _children = children,_statuses = statuses,_userRounds = userRounds,super._();
  

 final  List<UserModel> _children;
@override@JsonKey() List<UserModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  List<UserStatusModel> _statuses;
@override@JsonKey() List<UserStatusModel> get statuses {
  if (_statuses is EqualUnmodifiableListView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statuses);
}

 final  List<UserRoundModel> _userRounds;
@override@JsonKey() List<UserRoundModel> get userRounds {
  if (_userRounds is EqualUnmodifiableListView) return _userRounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userRounds);
}

@override@JsonKey() final  BaseState status;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&const DeepCollectionEquality().equals(other.children, _children)&&const DeepCollectionEquality().equals(other.statuses, _statuses)&&const DeepCollectionEquality().equals(other.userRounds, _userRounds)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_statuses),const DeepCollectionEquality().hash(_userRounds),status);
}

@override
String toString() {
    return 'ProfileState(children: $children, statuses: $statuses, userRounds: $userRounds, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 List<UserModel> children, List<UserStatusModel> statuses, List<UserRoundModel> userRounds, BaseState status
});


@override $BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? children = null,Object? statuses = null,Object? userRounds = null,Object? status = null,}) {
  return _then(_ProfileState(
children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<UserModel>,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<UserStatusModel>,userRounds: null == userRounds ? _self._userRounds : userRounds // ignore: cast_nullable_to_non_nullable
as List<UserRoundModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,
  ));
}

/// Create a copy of ProfileState
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
