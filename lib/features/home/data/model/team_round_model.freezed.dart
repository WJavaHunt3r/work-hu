// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_round_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TeamRoundModel _$TeamRoundModelFromJson(Map<String, dynamic> json) {
  return _TeamRoundModel.fromJson(json);
}

/// @nodoc
mixin _$TeamRoundModel {
  num get id => throw _privateConstructorUsedError;
  RoundModel get round => throw _privateConstructorUsedError;
  TeamModel get team => throw _privateConstructorUsedError;
  double get teamPoints => throw _privateConstructorUsedError;
  double get samvirkPayments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamRoundModelCopyWith<TeamRoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamRoundModelCopyWith<$Res> {
  factory $TeamRoundModelCopyWith(
          TeamRoundModel value, $Res Function(TeamRoundModel) then) =
      _$TeamRoundModelCopyWithImpl<$Res, TeamRoundModel>;
  @useResult
  $Res call(
      {num id,
      RoundModel round,
      TeamModel team,
      double teamPoints,
      double samvirkPayments});

  $RoundModelCopyWith<$Res> get round;
  $TeamModelCopyWith<$Res> get team;
}

/// @nodoc
class _$TeamRoundModelCopyWithImpl<$Res, $Val extends TeamRoundModel>
    implements $TeamRoundModelCopyWith<$Res> {
  _$TeamRoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? round = null,
    Object? team = null,
    Object? teamPoints = null,
    Object? samvirkPayments = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as RoundModel,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as TeamModel,
      teamPoints: null == teamPoints
          ? _value.teamPoints
          : teamPoints // ignore: cast_nullable_to_non_nullable
              as double,
      samvirkPayments: null == samvirkPayments
          ? _value.samvirkPayments
          : samvirkPayments // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoundModelCopyWith<$Res> get round {
    return $RoundModelCopyWith<$Res>(_value.round, (value) {
      return _then(_value.copyWith(round: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamModelCopyWith<$Res> get team {
    return $TeamModelCopyWith<$Res>(_value.team, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TeamRoundModelCopyWith<$Res>
    implements $TeamRoundModelCopyWith<$Res> {
  factory _$$_TeamRoundModelCopyWith(
          _$_TeamRoundModel value, $Res Function(_$_TeamRoundModel) then) =
      __$$_TeamRoundModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num id,
      RoundModel round,
      TeamModel team,
      double teamPoints,
      double samvirkPayments});

  @override
  $RoundModelCopyWith<$Res> get round;
  @override
  $TeamModelCopyWith<$Res> get team;
}

/// @nodoc
class __$$_TeamRoundModelCopyWithImpl<$Res>
    extends _$TeamRoundModelCopyWithImpl<$Res, _$_TeamRoundModel>
    implements _$$_TeamRoundModelCopyWith<$Res> {
  __$$_TeamRoundModelCopyWithImpl(
      _$_TeamRoundModel _value, $Res Function(_$_TeamRoundModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? round = null,
    Object? team = null,
    Object? teamPoints = null,
    Object? samvirkPayments = null,
  }) {
    return _then(_$_TeamRoundModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as RoundModel,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as TeamModel,
      teamPoints: null == teamPoints
          ? _value.teamPoints
          : teamPoints // ignore: cast_nullable_to_non_nullable
              as double,
      samvirkPayments: null == samvirkPayments
          ? _value.samvirkPayments
          : samvirkPayments // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TeamRoundModel implements _TeamRoundModel {
  const _$_TeamRoundModel(
      {required this.id,
      required this.round,
      required this.team,
      required this.teamPoints,
      required this.samvirkPayments});

  factory _$_TeamRoundModel.fromJson(Map<String, dynamic> json) =>
      _$$_TeamRoundModelFromJson(json);

  @override
  final num id;
  @override
  final RoundModel round;
  @override
  final TeamModel team;
  @override
  final double teamPoints;
  @override
  final double samvirkPayments;

  @override
  String toString() {
    return 'TeamRoundModel(id: $id, round: $round, team: $team, teamPoints: $teamPoints, samvirkPayments: $samvirkPayments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TeamRoundModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.teamPoints, teamPoints) ||
                other.teamPoints == teamPoints) &&
            (identical(other.samvirkPayments, samvirkPayments) ||
                other.samvirkPayments == samvirkPayments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, round, team, teamPoints, samvirkPayments);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TeamRoundModelCopyWith<_$_TeamRoundModel> get copyWith =>
      __$$_TeamRoundModelCopyWithImpl<_$_TeamRoundModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TeamRoundModelToJson(
      this,
    );
  }
}

abstract class _TeamRoundModel implements TeamRoundModel {
  const factory _TeamRoundModel(
      {required final num id,
      required final RoundModel round,
      required final TeamModel team,
      required final double teamPoints,
      required final double samvirkPayments}) = _$_TeamRoundModel;

  factory _TeamRoundModel.fromJson(Map<String, dynamic> json) =
      _$_TeamRoundModel.fromJson;

  @override
  num get id;
  @override
  RoundModel get round;
  @override
  TeamModel get team;
  @override
  double get teamPoints;
  @override
  double get samvirkPayments;
  @override
  @JsonKey(ignore: true)
  _$$_TeamRoundModelCopyWith<_$_TeamRoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}
