// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileState {
  List<UserRoundModel> get userRounds => throw _privateConstructorUsedError;
  GoalModel? get userGoal => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call(
      {List<UserRoundModel> userRounds,
      GoalModel? userGoal,
      ModelState modelState});

  $GoalModelCopyWith<$Res>? get userGoal;
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRounds = null,
    Object? userGoal = freezed,
    Object? modelState = null,
  }) {
    return _then(_value.copyWith(
      userRounds: null == userRounds
          ? _value.userRounds
          : userRounds // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      userGoal: freezed == userGoal
          ? _value.userGoal
          : userGoal // ignore: cast_nullable_to_non_nullable
              as GoalModel?,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GoalModelCopyWith<$Res>? get userGoal {
    if (_value.userGoal == null) {
      return null;
    }

    return $GoalModelCopyWith<$Res>(_value.userGoal!, (value) {
      return _then(_value.copyWith(userGoal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ProfileStateCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$_ProfileStateCopyWith(
          _$_ProfileState value, $Res Function(_$_ProfileState) then) =
      __$$_ProfileStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserRoundModel> userRounds,
      GoalModel? userGoal,
      ModelState modelState});

  @override
  $GoalModelCopyWith<$Res>? get userGoal;
}

/// @nodoc
class __$$_ProfileStateCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$_ProfileState>
    implements _$$_ProfileStateCopyWith<$Res> {
  __$$_ProfileStateCopyWithImpl(
      _$_ProfileState _value, $Res Function(_$_ProfileState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRounds = null,
    Object? userGoal = freezed,
    Object? modelState = null,
  }) {
    return _then(_$_ProfileState(
      userRounds: null == userRounds
          ? _value._userRounds
          : userRounds // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      userGoal: freezed == userGoal
          ? _value.userGoal
          : userGoal // ignore: cast_nullable_to_non_nullable
              as GoalModel?,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
    ));
  }
}

/// @nodoc

class _$_ProfileState extends _ProfileState {
  const _$_ProfileState(
      {final List<UserRoundModel> userRounds = const [],
      this.userGoal,
      this.modelState = ModelState.empty})
      : _userRounds = userRounds,
        super._();

  final List<UserRoundModel> _userRounds;
  @override
  @JsonKey()
  List<UserRoundModel> get userRounds {
    if (_userRounds is EqualUnmodifiableListView) return _userRounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userRounds);
  }

  @override
  final GoalModel? userGoal;
  @override
  @JsonKey()
  final ModelState modelState;

  @override
  String toString() {
    return 'ProfileState(userRounds: $userRounds, userGoal: $userGoal, modelState: $modelState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileState &&
            const DeepCollectionEquality()
                .equals(other._userRounds, _userRounds) &&
            (identical(other.userGoal, userGoal) ||
                other.userGoal == userGoal) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_userRounds), userGoal, modelState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileStateCopyWith<_$_ProfileState> get copyWith =>
      __$$_ProfileStateCopyWithImpl<_$_ProfileState>(this, _$identity);
}

abstract class _ProfileState extends ProfileState {
  const factory _ProfileState(
      {final List<UserRoundModel> userRounds,
      final GoalModel? userGoal,
      final ModelState modelState}) = _$_ProfileState;
  const _ProfileState._() : super._();

  @override
  List<UserRoundModel> get userRounds;
  @override
  GoalModel? get userGoal;
  @override
  ModelState get modelState;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileStateCopyWith<_$_ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}
