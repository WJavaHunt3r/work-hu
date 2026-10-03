// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationPreferencesState {

 BaseState get status; List<NotificationPreferenceModel> get preferences;/// Whether this device may show pushes (OS / browser permission).
 bool get pushAllowed; bool get pushAvailable;
/// Create a copy of NotificationPreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesStateCopyWith<NotificationPreferencesState> get copyWith => _$NotificationPreferencesStateCopyWithImpl<NotificationPreferencesState>(this as NotificationPreferencesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationPreferencesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferencesState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.preferences, _this.preferences)&&(identical(other.pushAllowed, _this.pushAllowed) || other.pushAllowed == _this.pushAllowed)&&(identical(other.pushAvailable, _this.pushAvailable) || other.pushAvailable == _this.pushAvailable));
}


@override
int get hashCode {
  final _this = this as NotificationPreferencesState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.preferences),_this.pushAllowed,_this.pushAvailable);
}

@override
String toString() {
  final _this = this as NotificationPreferencesState;
  return 'NotificationPreferencesState(status: ${_this.status}, preferences: ${_this.preferences}, pushAllowed: ${_this.pushAllowed}, pushAvailable: ${_this.pushAvailable})';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesStateCopyWith<$Res>  {
  factory $NotificationPreferencesStateCopyWith(NotificationPreferencesState value, $Res Function(NotificationPreferencesState) _then) = _$NotificationPreferencesStateCopyWithImpl;
@useResult
$Res call({
 BaseState status, List<NotificationPreferenceModel> preferences, bool pushAllowed, bool pushAvailable
});


$BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class _$NotificationPreferencesStateCopyWithImpl<$Res>
    implements $NotificationPreferencesStateCopyWith<$Res> {
  _$NotificationPreferencesStateCopyWithImpl(this._self, this._then);

  final NotificationPreferencesState _self;
  final $Res Function(NotificationPreferencesState) _then;

/// Create a copy of NotificationPreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? preferences = null,Object? pushAllowed = null,Object? pushAvailable = null,}) {
  return _then(NotificationPreferencesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<NotificationPreferenceModel>,pushAllowed: null == pushAllowed ? _self.pushAllowed : pushAllowed // ignore: cast_nullable_to_non_nullable
as bool,pushAvailable: null == pushAvailable ? _self.pushAvailable : pushAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of NotificationPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStateCopyWith<$Res> get status {
  
  return $BaseStateCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationPreferencesState].
extension NotificationPreferencesStatePatterns on NotificationPreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferencesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BaseState status,  List<NotificationPreferenceModel> preferences,  bool pushAllowed,  bool pushAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferencesState() when $default != null:
return $default(_that.status,_that.preferences,_that.pushAllowed,_that.pushAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BaseState status,  List<NotificationPreferenceModel> preferences,  bool pushAllowed,  bool pushAvailable)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesState():
return $default(_that.status,_that.preferences,_that.pushAllowed,_that.pushAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BaseState status,  List<NotificationPreferenceModel> preferences,  bool pushAllowed,  bool pushAvailable)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesState() when $default != null:
return $default(_that.status,_that.preferences,_that.pushAllowed,_that.pushAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPreferencesState extends NotificationPreferencesState {
  const _NotificationPreferencesState({this.status = const BaseState(),  List<NotificationPreferenceModel> preferences = const [], this.pushAllowed = false, this.pushAvailable = false}): _preferences = preferences,super._();
  

@override@JsonKey() final  BaseState status;
 final  List<NotificationPreferenceModel> _preferences;
@override@JsonKey() List<NotificationPreferenceModel> get preferences {
  if (_preferences is EqualUnmodifiableListView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferences);
}

/// Whether this device may show pushes (OS / browser permission).
@override@JsonKey() final  bool pushAllowed;
@override@JsonKey() final  bool pushAvailable;

/// Create a copy of NotificationPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesStateCopyWith<_NotificationPreferencesState> get copyWith => __$NotificationPreferencesStateCopyWithImpl<_NotificationPreferencesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferencesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.preferences, _preferences)&&(identical(other.pushAllowed, pushAllowed) || other.pushAllowed == pushAllowed)&&(identical(other.pushAvailable, pushAvailable) || other.pushAvailable == pushAvailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_preferences),pushAllowed,pushAvailable);
}

@override
String toString() {
    return 'NotificationPreferencesState(status: $status, preferences: $preferences, pushAllowed: $pushAllowed, pushAvailable: $pushAvailable)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesStateCopyWith<$Res> implements $NotificationPreferencesStateCopyWith<$Res> {
  factory _$NotificationPreferencesStateCopyWith(_NotificationPreferencesState value, $Res Function(_NotificationPreferencesState) _then) = __$NotificationPreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 BaseState status, List<NotificationPreferenceModel> preferences, bool pushAllowed, bool pushAvailable
});


@override $BaseStateCopyWith<$Res> get status;

}
/// @nodoc
class __$NotificationPreferencesStateCopyWithImpl<$Res>
    implements _$NotificationPreferencesStateCopyWith<$Res> {
  __$NotificationPreferencesStateCopyWithImpl(this._self, this._then);

  final _NotificationPreferencesState _self;
  final $Res Function(_NotificationPreferencesState) _then;

/// Create a copy of NotificationPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? preferences = null,Object? pushAllowed = null,Object? pushAvailable = null,}) {
  return _then(_NotificationPreferencesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BaseState,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<NotificationPreferenceModel>,pushAllowed: null == pushAllowed ? _self.pushAllowed : pushAllowed // ignore: cast_nullable_to_non_nullable
as bool,pushAvailable: null == pushAvailable ? _self.pushAvailable : pushAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of NotificationPreferencesState
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
