// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_items_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TransactionItemsState {
  List<TransactionItemModel> get transactionItems =>
      throw _privateConstructorUsedError;
  num get transactionId => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionItemsStateCopyWith<TransactionItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionItemsStateCopyWith<$Res> {
  factory $TransactionItemsStateCopyWith(TransactionItemsState value,
          $Res Function(TransactionItemsState) then) =
      _$TransactionItemsStateCopyWithImpl<$Res, TransactionItemsState>;
  @useResult
  $Res call(
      {List<TransactionItemModel> transactionItems,
      num transactionId,
      ModelState modelState,
      String message});
}

/// @nodoc
class _$TransactionItemsStateCopyWithImpl<$Res,
        $Val extends TransactionItemsState>
    implements $TransactionItemsStateCopyWith<$Res> {
  _$TransactionItemsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionItems = null,
    Object? transactionId = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      transactionItems: null == transactionItems
          ? _value.transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as num,
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
abstract class _$$_TransactionItemsStateCopyWith<$Res>
    implements $TransactionItemsStateCopyWith<$Res> {
  factory _$$_TransactionItemsStateCopyWith(_$_TransactionItemsState value,
          $Res Function(_$_TransactionItemsState) then) =
      __$$_TransactionItemsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransactionItemModel> transactionItems,
      num transactionId,
      ModelState modelState,
      String message});
}

/// @nodoc
class __$$_TransactionItemsStateCopyWithImpl<$Res>
    extends _$TransactionItemsStateCopyWithImpl<$Res, _$_TransactionItemsState>
    implements _$$_TransactionItemsStateCopyWith<$Res> {
  __$$_TransactionItemsStateCopyWithImpl(_$_TransactionItemsState _value,
      $Res Function(_$_TransactionItemsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionItems = null,
    Object? transactionId = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_TransactionItemsState(
      transactionItems: null == transactionItems
          ? _value._transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as num,
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

class _$_TransactionItemsState extends _TransactionItemsState {
  const _$_TransactionItemsState(
      {final List<TransactionItemModel> transactionItems = const [],
      this.transactionId = 0,
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
  final num transactionId;
  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'TransactionItemsState(transactionItems: $transactionItems, transactionId: $transactionId, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TransactionItemsState &&
            const DeepCollectionEquality()
                .equals(other._transactionItems, _transactionItems) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transactionItems),
      transactionId,
      modelState,
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TransactionItemsStateCopyWith<_$_TransactionItemsState> get copyWith =>
      __$$_TransactionItemsStateCopyWithImpl<_$_TransactionItemsState>(
          this, _$identity);
}

abstract class _TransactionItemsState extends TransactionItemsState {
  const factory _TransactionItemsState(
      {final List<TransactionItemModel> transactionItems,
      final num transactionId,
      final ModelState modelState,
      final String message}) = _$_TransactionItemsState;
  const _TransactionItemsState._() : super._();

  @override
  List<TransactionItemModel> get transactionItems;
  @override
  num get transactionId;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_TransactionItemsStateCopyWith<_$_TransactionItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}
