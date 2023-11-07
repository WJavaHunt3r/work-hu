// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_points_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserPointsState {
  List<TransactionItemModel> get transactionItems =>
      throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserPointsStateCopyWith<UserPointsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPointsStateCopyWith<$Res> {
  factory $UserPointsStateCopyWith(
          UserPointsState value, $Res Function(UserPointsState) then) =
      _$UserPointsStateCopyWithImpl<$Res, UserPointsState>;
  @useResult
  $Res call(
      {List<TransactionItemModel> transactionItems,
      ModelState modelState,
      String message});
}

/// @nodoc
class _$UserPointsStateCopyWithImpl<$Res, $Val extends UserPointsState>
    implements $UserPointsStateCopyWith<$Res> {
  _$UserPointsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionItems = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      transactionItems: null == transactionItems
          ? _value.transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
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
abstract class _$$_UserPointsStateCopyWith<$Res>
    implements $UserPointsStateCopyWith<$Res> {
  factory _$$_UserPointsStateCopyWith(
          _$_UserPointsState value, $Res Function(_$_UserPointsState) then) =
      __$$_UserPointsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransactionItemModel> transactionItems,
      ModelState modelState,
      String message});
}

/// @nodoc
class __$$_UserPointsStateCopyWithImpl<$Res>
    extends _$UserPointsStateCopyWithImpl<$Res, _$_UserPointsState>
    implements _$$_UserPointsStateCopyWith<$Res> {
  __$$_UserPointsStateCopyWithImpl(
      _$_UserPointsState _value, $Res Function(_$_UserPointsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionItems = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_UserPointsState(
      transactionItems: null == transactionItems
          ? _value._transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
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

class _$_UserPointsState extends _UserPointsState {
  const _$_UserPointsState(
      {final List<TransactionItemModel> transactionItems = const [],
      this.modelState = ModelState.empty,
      this.message = ""})
      : _transactionItems = transactionItems,
        super._();

  final List<TransactionItemModel> _transactionItems;
  @override
  @JsonKey()
  List<TransactionItemModel> get transactionItems {
    if (_transactionItems is EqualUnmodifiableListView)
      return _transactionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactionItems);
  }

  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'UserPointsState(transactionItems: $transactionItems, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserPointsState &&
            const DeepCollectionEquality()
                .equals(other._transactionItems, _transactionItems) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transactionItems),
      modelState,
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserPointsStateCopyWith<_$_UserPointsState> get copyWith =>
      __$$_UserPointsStateCopyWithImpl<_$_UserPointsState>(this, _$identity);
}

abstract class _UserPointsState extends UserPointsState {
  const factory _UserPointsState(
      {final List<TransactionItemModel> transactionItems,
      final ModelState modelState,
      final String message}) = _$_UserPointsState;
  const _UserPointsState._() : super._();

  @override
  List<TransactionItemModel> get transactionItems;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_UserPointsStateCopyWith<_$_UserPointsState> get copyWith =>
      throw _privateConstructorUsedError;
}
