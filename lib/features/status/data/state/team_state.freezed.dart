// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TeamState {
  List<TeamModel> get teams => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TeamStateCopyWith<TeamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamStateCopyWith<$Res> {
  factory $TeamStateCopyWith(TeamState value, $Res Function(TeamState) then) =
      _$TeamStateCopyWithImpl<$Res, TeamState>;
  @useResult
  $Res call({List<TeamModel> teams, bool isLoading});
}

/// @nodoc
class _$TeamStateCopyWithImpl<$Res, $Val extends TeamState>
    implements $TeamStateCopyWith<$Res> {
  _$TeamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teams = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      teams: null == teams
          ? _value.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TeamStateCopyWith<$Res> implements $TeamStateCopyWith<$Res> {
  factory _$$_TeamStateCopyWith(
          _$_TeamState value, $Res Function(_$_TeamState) then) =
      __$$_TeamStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TeamModel> teams, bool isLoading});
}

/// @nodoc
class __$$_TeamStateCopyWithImpl<$Res>
    extends _$TeamStateCopyWithImpl<$Res, _$_TeamState>
    implements _$$_TeamStateCopyWith<$Res> {
  __$$_TeamStateCopyWithImpl(
      _$_TeamState _value, $Res Function(_$_TeamState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teams = null,
    Object? isLoading = null,
  }) {
    return _then(_$_TeamState(
      teams: null == teams
          ? _value._teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_TeamState extends _TeamState {
  const _$_TeamState(
      {final List<TeamModel> teams = const [], this.isLoading = true})
      : _teams = teams,
        super._();

  final List<TeamModel> _teams;
  @override
  @JsonKey()
  List<TeamModel> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'TeamState(teams: $teams, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TeamState &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_teams), isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TeamStateCopyWith<_$_TeamState> get copyWith =>
      __$$_TeamStateCopyWithImpl<_$_TeamState>(this, _$identity);
}

abstract class _TeamState extends TeamState {
  const factory _TeamState(
      {final List<TeamModel> teams, final bool isLoading}) = _$_TeamState;
  const _TeamState._() : super._();

  @override
  List<TeamModel> get teams;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_TeamStateCopyWith<_$_TeamState> get copyWith =>
      throw _privateConstructorUsedError;
}
