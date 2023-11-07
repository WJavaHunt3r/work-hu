// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_round_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TeamRoundState {
  List<TeamRoundModel> get teams => throw _privateConstructorUsedError;
  List<UserRoundModel> get users => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TeamRoundStateCopyWith<TeamRoundState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamRoundStateCopyWith<$Res> {
  factory $TeamRoundStateCopyWith(
          TeamRoundState value, $Res Function(TeamRoundState) then) =
      _$TeamRoundStateCopyWithImpl<$Res, TeamRoundState>;
  @useResult
  $Res call(
      {List<TeamRoundModel> teams,
      List<UserRoundModel> users,
      ModelState modelState});
}

/// @nodoc
class _$TeamRoundStateCopyWithImpl<$Res, $Val extends TeamRoundState>
    implements $TeamRoundStateCopyWith<$Res> {
  _$TeamRoundStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teams = null,
    Object? users = null,
    Object? modelState = null,
  }) {
    return _then(_value.copyWith(
      teams: null == teams
          ? _value.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamRoundModel>,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TeamRoundStateCopyWith<$Res>
    implements $TeamRoundStateCopyWith<$Res> {
  factory _$$_TeamRoundStateCopyWith(
          _$_TeamRoundState value, $Res Function(_$_TeamRoundState) then) =
      __$$_TeamRoundStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TeamRoundModel> teams,
      List<UserRoundModel> users,
      ModelState modelState});
}

/// @nodoc
class __$$_TeamRoundStateCopyWithImpl<$Res>
    extends _$TeamRoundStateCopyWithImpl<$Res, _$_TeamRoundState>
    implements _$$_TeamRoundStateCopyWith<$Res> {
  __$$_TeamRoundStateCopyWithImpl(
      _$_TeamRoundState _value, $Res Function(_$_TeamRoundState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teams = null,
    Object? users = null,
    Object? modelState = null,
  }) {
    return _then(_$_TeamRoundState(
      teams: null == teams
          ? _value._teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamRoundModel>,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
    ));
  }
}

/// @nodoc

class _$_TeamRoundState extends _TeamRoundState {
  const _$_TeamRoundState(
      {final List<TeamRoundModel> teams = const [],
      final List<UserRoundModel> users = const [],
      this.modelState = ModelState.empty})
      : _teams = teams,
        _users = users,
        super._();

  final List<TeamRoundModel> _teams;
  @override
  @JsonKey()
  List<TeamRoundModel> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  final List<UserRoundModel> _users;
  @override
  @JsonKey()
  List<UserRoundModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey()
  final ModelState modelState;

  @override
  String toString() {
    return 'TeamRoundState(teams: $teams, users: $users, modelState: $modelState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TeamRoundState &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_teams),
      const DeepCollectionEquality().hash(_users),
      modelState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TeamRoundStateCopyWith<_$_TeamRoundState> get copyWith =>
      __$$_TeamRoundStateCopyWithImpl<_$_TeamRoundState>(this, _$identity);
}

abstract class _TeamRoundState extends TeamRoundState {
  const factory _TeamRoundState(
      {final List<TeamRoundModel> teams,
      final List<UserRoundModel> users,
      final ModelState modelState}) = _$_TeamRoundState;
  const _TeamRoundState._() : super._();

  @override
  List<TeamRoundModel> get teams;
  @override
  List<UserRoundModel> get users;
  @override
  ModelState get modelState;
  @override
  @JsonKey(ignore: true)
  _$$_TeamRoundStateCopyWith<_$_TeamRoundState> get copyWith =>
      throw _privateConstructorUsedError;
}
