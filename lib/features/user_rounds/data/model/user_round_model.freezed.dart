// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_round_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRoundModel {

 RoundModel get round; UserModel get user; int get samvirkPayments; double? get bmmperfectWeekPoints; num get roundCoins; num get roundCredits; num get roundMyShareGoal;
/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRoundModelCopyWith<UserRoundModel> get copyWith => _$UserRoundModelCopyWithImpl<UserRoundModel>(this as UserRoundModel, _$identity);

  /// Serializes this UserRoundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRoundModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRoundModel&&(identical(other.round, _this.round) || other.round == _this.round)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.samvirkPayments, _this.samvirkPayments) || other.samvirkPayments == _this.samvirkPayments)&&(identical(other.bmmperfectWeekPoints, _this.bmmperfectWeekPoints) || other.bmmperfectWeekPoints == _this.bmmperfectWeekPoints)&&(identical(other.roundCoins, _this.roundCoins) || other.roundCoins == _this.roundCoins)&&(identical(other.roundCredits, _this.roundCredits) || other.roundCredits == _this.roundCredits)&&(identical(other.roundMyShareGoal, _this.roundMyShareGoal) || other.roundMyShareGoal == _this.roundMyShareGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRoundModel;
  return Object.hash(runtimeType,_this.round,_this.user,_this.samvirkPayments,_this.bmmperfectWeekPoints,_this.roundCoins,_this.roundCredits,_this.roundMyShareGoal);
}

@override
String toString() {
  final _this = this as UserRoundModel;
  return 'UserRoundModel(round: ${_this.round}, user: ${_this.user}, samvirkPayments: ${_this.samvirkPayments}, bmmperfectWeekPoints: ${_this.bmmperfectWeekPoints}, roundCoins: ${_this.roundCoins}, roundCredits: ${_this.roundCredits}, roundMyShareGoal: ${_this.roundMyShareGoal})';
}


}

/// @nodoc
abstract mixin class $UserRoundModelCopyWith<$Res>  {
  factory $UserRoundModelCopyWith(UserRoundModel value, $Res Function(UserRoundModel) _then) = _$UserRoundModelCopyWithImpl;
@useResult
$Res call({
 RoundModel round, UserModel user, int samvirkPayments, double? bmmperfectWeekPoints, num roundCoins, num roundCredits, num roundMyShareGoal
});


$RoundModelCopyWith<$Res> get round;$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$UserRoundModelCopyWithImpl<$Res>
    implements $UserRoundModelCopyWith<$Res> {
  _$UserRoundModelCopyWithImpl(this._self, this._then);

  final UserRoundModel _self;
  final $Res Function(UserRoundModel) _then;

/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? round = null,Object? user = null,Object? samvirkPayments = null,Object? bmmperfectWeekPoints = freezed,Object? roundCoins = null,Object? roundCredits = null,Object? roundMyShareGoal = null,}) {
  return _then(UserRoundModel(
round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as RoundModel,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,samvirkPayments: null == samvirkPayments ? _self.samvirkPayments : samvirkPayments // ignore: cast_nullable_to_non_nullable
as int,bmmperfectWeekPoints: freezed == bmmperfectWeekPoints ? _self.bmmperfectWeekPoints : bmmperfectWeekPoints // ignore: cast_nullable_to_non_nullable
as double?,roundCoins: null == roundCoins ? _self.roundCoins : roundCoins // ignore: cast_nullable_to_non_nullable
as num,roundCredits: null == roundCredits ? _self.roundCredits : roundCredits // ignore: cast_nullable_to_non_nullable
as num,roundMyShareGoal: null == roundMyShareGoal ? _self.roundMyShareGoal : roundMyShareGoal // ignore: cast_nullable_to_non_nullable
as num,
  ));
}
/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoundModelCopyWith<$Res> get round {
  
  return $RoundModelCopyWith<$Res>(_self.round, (value) {
    return _then(_self.copyWith(round: value));
  });
}/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserRoundModel].
extension UserRoundModelPatterns on UserRoundModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRoundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRoundModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRoundModel value)  $default,){
final _that = this;
switch (_that) {
case _UserRoundModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRoundModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserRoundModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoundModel round,  UserModel user,  int samvirkPayments,  double? bmmperfectWeekPoints,  num roundCoins,  num roundCredits,  num roundMyShareGoal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRoundModel() when $default != null:
return $default(_that.round,_that.user,_that.samvirkPayments,_that.bmmperfectWeekPoints,_that.roundCoins,_that.roundCredits,_that.roundMyShareGoal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoundModel round,  UserModel user,  int samvirkPayments,  double? bmmperfectWeekPoints,  num roundCoins,  num roundCredits,  num roundMyShareGoal)  $default,) {final _that = this;
switch (_that) {
case _UserRoundModel():
return $default(_that.round,_that.user,_that.samvirkPayments,_that.bmmperfectWeekPoints,_that.roundCoins,_that.roundCredits,_that.roundMyShareGoal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoundModel round,  UserModel user,  int samvirkPayments,  double? bmmperfectWeekPoints,  num roundCoins,  num roundCredits,  num roundMyShareGoal)?  $default,) {final _that = this;
switch (_that) {
case _UserRoundModel() when $default != null:
return $default(_that.round,_that.user,_that.samvirkPayments,_that.bmmperfectWeekPoints,_that.roundCoins,_that.roundCredits,_that.roundMyShareGoal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRoundModel implements UserRoundModel {
  const _UserRoundModel({required this.round, required this.user, required this.samvirkPayments, this.bmmperfectWeekPoints, required this.roundCoins, required this.roundCredits, required this.roundMyShareGoal});
  factory _UserRoundModel.fromJson(Map<String, dynamic> json) => _$UserRoundModelFromJson(json);

@override final  RoundModel round;
@override final  UserModel user;
@override final  int samvirkPayments;
@override final  double? bmmperfectWeekPoints;
@override final  num roundCoins;
@override final  num roundCredits;
@override final  num roundMyShareGoal;

/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRoundModelCopyWith<_UserRoundModel> get copyWith => __$UserRoundModelCopyWithImpl<_UserRoundModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRoundModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRoundModel&&(identical(other.round, round) || other.round == round)&&(identical(other.user, user) || other.user == user)&&(identical(other.samvirkPayments, samvirkPayments) || other.samvirkPayments == samvirkPayments)&&(identical(other.bmmperfectWeekPoints, bmmperfectWeekPoints) || other.bmmperfectWeekPoints == bmmperfectWeekPoints)&&(identical(other.roundCoins, roundCoins) || other.roundCoins == roundCoins)&&(identical(other.roundCredits, roundCredits) || other.roundCredits == roundCredits)&&(identical(other.roundMyShareGoal, roundMyShareGoal) || other.roundMyShareGoal == roundMyShareGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,round,user,samvirkPayments,bmmperfectWeekPoints,roundCoins,roundCredits,roundMyShareGoal);
}

@override
String toString() {
    return 'UserRoundModel(round: $round, user: $user, samvirkPayments: $samvirkPayments, bmmperfectWeekPoints: $bmmperfectWeekPoints, roundCoins: $roundCoins, roundCredits: $roundCredits, roundMyShareGoal: $roundMyShareGoal)';
}


}

/// @nodoc
abstract mixin class _$UserRoundModelCopyWith<$Res> implements $UserRoundModelCopyWith<$Res> {
  factory _$UserRoundModelCopyWith(_UserRoundModel value, $Res Function(_UserRoundModel) _then) = __$UserRoundModelCopyWithImpl;
@override @useResult
$Res call({
 RoundModel round, UserModel user, int samvirkPayments, double? bmmperfectWeekPoints, num roundCoins, num roundCredits, num roundMyShareGoal
});


@override $RoundModelCopyWith<$Res> get round;@override $UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$UserRoundModelCopyWithImpl<$Res>
    implements _$UserRoundModelCopyWith<$Res> {
  __$UserRoundModelCopyWithImpl(this._self, this._then);

  final _UserRoundModel _self;
  final $Res Function(_UserRoundModel) _then;

/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? round = null,Object? user = null,Object? samvirkPayments = null,Object? bmmperfectWeekPoints = freezed,Object? roundCoins = null,Object? roundCredits = null,Object? roundMyShareGoal = null,}) {
  return _then(_UserRoundModel(
round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as RoundModel,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,samvirkPayments: null == samvirkPayments ? _self.samvirkPayments : samvirkPayments // ignore: cast_nullable_to_non_nullable
as int,bmmperfectWeekPoints: freezed == bmmperfectWeekPoints ? _self.bmmperfectWeekPoints : bmmperfectWeekPoints // ignore: cast_nullable_to_non_nullable
as double?,roundCoins: null == roundCoins ? _self.roundCoins : roundCoins // ignore: cast_nullable_to_non_nullable
as num,roundCredits: null == roundCredits ? _self.roundCredits : roundCredits // ignore: cast_nullable_to_non_nullable
as num,roundMyShareGoal: null == roundMyShareGoal ? _self.roundMyShareGoal : roundMyShareGoal // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoundModelCopyWith<$Res> get round {
  
  return $RoundModelCopyWith<$Res>(_self.round, (value) {
    return _then(_self.copyWith(round: value));
  });
}/// Create a copy of UserRoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
