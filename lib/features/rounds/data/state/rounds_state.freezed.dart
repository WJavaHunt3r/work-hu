// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rounds_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RoundsState {
  num get currentRoundNumber => throw _privateConstructorUsedError;
  List<RoundModel> get rounds => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoundsStateCopyWith<RoundsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundsStateCopyWith<$Res> {
  factory $RoundsStateCopyWith(
          RoundsState value, $Res Function(RoundsState) then) =
      _$RoundsStateCopyWithImpl<$Res, RoundsState>;
  @useResult
  $Res call(
      {num currentRoundNumber,
      List<RoundModel> rounds,
      ModelState modelState,
      String message});
}

/// @nodoc
class _$RoundsStateCopyWithImpl<$Res, $Val extends RoundsState>
    implements $RoundsStateCopyWith<$Res> {
  _$RoundsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRoundNumber = null,
    Object? rounds = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      currentRoundNumber: null == currentRoundNumber
          ? _value.currentRoundNumber
          : currentRoundNumber // ignore: cast_nullable_to_non_nullable
              as num,
      rounds: null == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<RoundModel>,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RoundsStateCopyWith<$Res>
    implements $RoundsStateCopyWith<$Res> {
  factory _$$_RoundsStateCopyWith(
          _$_RoundsState value, $Res Function(_$_RoundsState) then) =
      __$$_RoundsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num currentRoundNumber,
      List<RoundModel> rounds,
      ModelState modelState,
      String message});
}

/// @nodoc
class __$$_RoundsStateCopyWithImpl<$Res>
    extends _$RoundsStateCopyWithImpl<$Res, _$_RoundsState>
    implements _$$_RoundsStateCopyWith<$Res> {
  __$$_RoundsStateCopyWithImpl(
      _$_RoundsState _value, $Res Function(_$_RoundsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRoundNumber = null,
    Object? rounds = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_RoundsState(
      currentRoundNumber: null == currentRoundNumber
          ? _value.currentRoundNumber
          : currentRoundNumber // ignore: cast_nullable_to_non_nullable
              as num,
      rounds: null == rounds
          ? _value._rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<RoundModel>,
      modelState: null == modelState
          ? _value.modelState
          : modelState // ignore: cast_nullable_to_non_nullable
              as ModelState,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_RoundsState extends _RoundsState {
  const _$_RoundsState(
      {this.currentRoundNumber = 0,
      final List<RoundModel> rounds = const [],
      this.modelState = ModelState.empty,
      this.message = ""})
      : _rounds = rounds,
        super._();

  @override
  @JsonKey()
  final num currentRoundNumber;
  final List<RoundModel> _rounds;
  @override
  @JsonKey()
  List<RoundModel> get rounds {
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rounds);
  }

  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'RoundsState(currentRoundNumber: $currentRoundNumber, rounds: $rounds, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RoundsState &&
            (identical(other.currentRoundNumber, currentRoundNumber) ||
                other.currentRoundNumber == currentRoundNumber) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentRoundNumber,
      const DeepCollectionEquality().hash(_rounds), modelState, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RoundsStateCopyWith<_$_RoundsState> get copyWith =>
      __$$_RoundsStateCopyWithImpl<_$_RoundsState>(this, _$identity);
}

abstract class _RoundsState extends RoundsState {
  const factory _RoundsState(
      {final num currentRoundNumber,
      final List<RoundModel> rounds,
      final ModelState modelState,
      final String message}) = _$_RoundsState;
  const _RoundsState._() : super._();

  @override
  num get currentRoundNumber;
  @override
  List<RoundModel> get rounds;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_RoundsStateCopyWith<_$_RoundsState> get copyWith =>
      throw _privateConstructorUsedError;
}
