// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_transactions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateTransactionsState {
  List<UserModel> get users => throw _privateConstructorUsedError;
  List<TransactionItemModel> get transactionItems =>
      throw _privateConstructorUsedError;
  DateTime? get transactionDate => throw _privateConstructorUsedError;
  TransactionType get transactionType => throw _privateConstructorUsedError;
  Account get account => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  num get sum => throw _privateConstructorUsedError;
  UserModel? get selectedUser => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateTransactionsStateCopyWith<CreateTransactionsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTransactionsStateCopyWith<$Res> {
  factory $CreateTransactionsStateCopyWith(CreateTransactionsState value,
          $Res Function(CreateTransactionsState) then) =
      _$CreateTransactionsStateCopyWithImpl<$Res, CreateTransactionsState>;
  @useResult
  $Res call(
      {List<UserModel> users,
      List<TransactionItemModel> transactionItems,
      DateTime? transactionDate,
      TransactionType transactionType,
      Account account,
      String description,
      num sum,
      UserModel? selectedUser,
      ModelState modelState,
      String message});

  $UserModelCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class _$CreateTransactionsStateCopyWithImpl<$Res,
        $Val extends CreateTransactionsState>
    implements $CreateTransactionsStateCopyWith<$Res> {
  _$CreateTransactionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? transactionItems = null,
    Object? transactionDate = freezed,
    Object? transactionType = null,
    Object? account = null,
    Object? description = null,
    Object? sum = null,
    Object? selectedUser = freezed,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      transactionItems: null == transactionItems
          ? _value.transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
      transactionDate: freezed == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as num,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get selectedUser {
    if (_value.selectedUser == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.selectedUser!, (value) {
      return _then(_value.copyWith(selectedUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CreateTransactionsStateCopyWith<$Res>
    implements $CreateTransactionsStateCopyWith<$Res> {
  factory _$$_CreateTransactionsStateCopyWith(_$_CreateTransactionsState value,
          $Res Function(_$_CreateTransactionsState) then) =
      __$$_CreateTransactionsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> users,
      List<TransactionItemModel> transactionItems,
      DateTime? transactionDate,
      TransactionType transactionType,
      Account account,
      String description,
      num sum,
      UserModel? selectedUser,
      ModelState modelState,
      String message});

  @override
  $UserModelCopyWith<$Res>? get selectedUser;
}

/// @nodoc
class __$$_CreateTransactionsStateCopyWithImpl<$Res>
    extends _$CreateTransactionsStateCopyWithImpl<$Res,
        _$_CreateTransactionsState>
    implements _$$_CreateTransactionsStateCopyWith<$Res> {
  __$$_CreateTransactionsStateCopyWithImpl(_$_CreateTransactionsState _value,
      $Res Function(_$_CreateTransactionsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? transactionItems = null,
    Object? transactionDate = freezed,
    Object? transactionType = null,
    Object? account = null,
    Object? description = null,
    Object? sum = null,
    Object? selectedUser = freezed,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_CreateTransactionsState(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      transactionItems: null == transactionItems
          ? _value._transactionItems
          : transactionItems // ignore: cast_nullable_to_non_nullable
              as List<TransactionItemModel>,
      transactionDate: freezed == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as num,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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

class _$_CreateTransactionsState extends _CreateTransactionsState {
  const _$_CreateTransactionsState(
      {final List<UserModel> users = const [],
      final List<TransactionItemModel> transactionItems = const [],
      this.transactionDate,
      this.transactionType = TransactionType.POINT,
      this.account = Account.OTHER,
      this.description = "",
      this.sum = 0,
      this.selectedUser,
      this.modelState = ModelState.empty,
      this.message = ""})
      : _users = users,
        _transactionItems = transactionItems,
        super._();

  final List<UserModel> _users;
  @override
  @JsonKey()
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

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
  final DateTime? transactionDate;
  @override
  @JsonKey()
  final TransactionType transactionType;
  @override
  @JsonKey()
  final Account account;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final num sum;
  @override
  final UserModel? selectedUser;
  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'CreateTransactionsState(users: $users, transactionItems: $transactionItems, transactionDate: $transactionDate, transactionType: $transactionType, account: $account, description: $description, sum: $sum, selectedUser: $selectedUser, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateTransactionsState &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality()
                .equals(other._transactionItems, _transactionItems) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sum, sum) || other.sum == sum) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(_transactionItems),
      transactionDate,
      transactionType,
      account,
      description,
      sum,
      selectedUser,
      modelState,
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreateTransactionsStateCopyWith<_$_CreateTransactionsState>
      get copyWith =>
          __$$_CreateTransactionsStateCopyWithImpl<_$_CreateTransactionsState>(
              this, _$identity);
}

abstract class _CreateTransactionsState extends CreateTransactionsState {
  const factory _CreateTransactionsState(
      {final List<UserModel> users,
      final List<TransactionItemModel> transactionItems,
      final DateTime? transactionDate,
      final TransactionType transactionType,
      final Account account,
      final String description,
      final num sum,
      final UserModel? selectedUser,
      final ModelState modelState,
      final String message}) = _$_CreateTransactionsState;
  const _CreateTransactionsState._() : super._();

  @override
  List<UserModel> get users;
  @override
  List<TransactionItemModel> get transactionItems;
  @override
  DateTime? get transactionDate;
  @override
  TransactionType get transactionType;
  @override
  Account get account;
  @override
  String get description;
  @override
  num get sum;
  @override
  UserModel? get selectedUser;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_CreateTransactionsStateCopyWith<_$_CreateTransactionsState>
      get copyWith => throw _privateConstructorUsedError;
}
