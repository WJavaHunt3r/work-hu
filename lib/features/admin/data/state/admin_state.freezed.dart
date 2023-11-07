// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AdminState {
  String get description => throw _privateConstructorUsedError;
  DateTime? get transactionDate => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminStateCopyWith<AdminState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStateCopyWith<$Res> {
  factory $AdminStateCopyWith(
          AdminState value, $Res Function(AdminState) then) =
      _$AdminStateCopyWithImpl<$Res, AdminState>;
  @useResult
  $Res call(
      {String description,
      DateTime? transactionDate,
      ModelState modelState,
      String message});
}

/// @nodoc
class _$AdminStateCopyWithImpl<$Res, $Val extends AdminState>
    implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? transactionDate = freezed,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: freezed == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$_AdminStateCopyWith<$Res>
    implements $AdminStateCopyWith<$Res> {
  factory _$$_AdminStateCopyWith(
          _$_AdminState value, $Res Function(_$_AdminState) then) =
      __$$_AdminStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      DateTime? transactionDate,
      ModelState modelState,
      String message});
}

/// @nodoc
class __$$_AdminStateCopyWithImpl<$Res>
    extends _$AdminStateCopyWithImpl<$Res, _$_AdminState>
    implements _$$_AdminStateCopyWith<$Res> {
  __$$_AdminStateCopyWithImpl(
      _$_AdminState _value, $Res Function(_$_AdminState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? transactionDate = freezed,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_AdminState(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: freezed == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

class _$_AdminState extends _AdminState {
  const _$_AdminState(
      {this.description = "",
      this.transactionDate,
      this.modelState = ModelState.empty,
      this.message = ""})
      : super._();

  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? transactionDate;
  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'AdminState(description: $description, transactionDate: $transactionDate, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AdminState &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, description, transactionDate, modelState, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AdminStateCopyWith<_$_AdminState> get copyWith =>
      __$$_AdminStateCopyWithImpl<_$_AdminState>(this, _$identity);
}

abstract class _AdminState extends AdminState {
  const factory _AdminState(
      {final String description,
      final DateTime? transactionDate,
      final ModelState modelState,
      final String message}) = _$_AdminState;
  const _AdminState._() : super._();

  @override
  String get description;
  @override
  DateTime? get transactionDate;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_AdminStateCopyWith<_$_AdminState> get copyWith =>
      throw _privateConstructorUsedError;
}
