// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TransactionItemModel _$TransactionItemModelFromJson(Map<String, dynamic> json) {
  return _TransactionItemModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionItemModel {
  num? get id => throw _privateConstructorUsedError;
  num? get transactionId => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  num get createUserId => throw _privateConstructorUsedError;
  double get points => throw _privateConstructorUsedError;
  TransactionType get transactionType => throw _privateConstructorUsedError;
  Account get account => throw _privateConstructorUsedError;
  num get credit => throw _privateConstructorUsedError;
  num get hours => throw _privateConstructorUsedError;
  RoundModel? get round => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionItemModelCopyWith<TransactionItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionItemModelCopyWith<$Res> {
  factory $TransactionItemModelCopyWith(TransactionItemModel value,
          $Res Function(TransactionItemModel) then) =
      _$TransactionItemModelCopyWithImpl<$Res, TransactionItemModel>;
  @useResult
  $Res call(
      {num? id,
      num? transactionId,
      DateTime transactionDate,
      String description,
      num createUserId,
      double points,
      TransactionType transactionType,
      Account account,
      num credit,
      num hours,
      RoundModel? round,
      UserModel user});

  $RoundModelCopyWith<$Res>? get round;
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$TransactionItemModelCopyWithImpl<$Res,
        $Val extends TransactionItemModel>
    implements $TransactionItemModelCopyWith<$Res> {
  _$TransactionItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transactionId = freezed,
    Object? transactionDate = null,
    Object? description = null,
    Object? createUserId = null,
    Object? points = null,
    Object? transactionType = null,
    Object? account = null,
    Object? credit = null,
    Object? hours = null,
    Object? round = freezed,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as num?,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createUserId: null == createUserId
          ? _value.createUserId
          : createUserId // ignore: cast_nullable_to_non_nullable
              as num,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as double,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as num,
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as num,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as RoundModel?,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoundModelCopyWith<$Res>? get round {
    if (_value.round == null) {
      return null;
    }

    return $RoundModelCopyWith<$Res>(_value.round!, (value) {
      return _then(_value.copyWith(round: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TransactionItemModelCopyWith<$Res>
    implements $TransactionItemModelCopyWith<$Res> {
  factory _$$_TransactionItemModelCopyWith(_$_TransactionItemModel value,
          $Res Function(_$_TransactionItemModel) then) =
      __$$_TransactionItemModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num? id,
      num? transactionId,
      DateTime transactionDate,
      String description,
      num createUserId,
      double points,
      TransactionType transactionType,
      Account account,
      num credit,
      num hours,
      RoundModel? round,
      UserModel user});

  @override
  $RoundModelCopyWith<$Res>? get round;
  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$_TransactionItemModelCopyWithImpl<$Res>
    extends _$TransactionItemModelCopyWithImpl<$Res, _$_TransactionItemModel>
    implements _$$_TransactionItemModelCopyWith<$Res> {
  __$$_TransactionItemModelCopyWithImpl(_$_TransactionItemModel _value,
      $Res Function(_$_TransactionItemModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transactionId = freezed,
    Object? transactionDate = null,
    Object? description = null,
    Object? createUserId = null,
    Object? points = null,
    Object? transactionType = null,
    Object? account = null,
    Object? credit = null,
    Object? hours = null,
    Object? round = freezed,
    Object? user = null,
  }) {
    return _then(_$_TransactionItemModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as num?,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createUserId: null == createUserId
          ? _value.createUserId
          : createUserId // ignore: cast_nullable_to_non_nullable
              as num,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as double,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as num,
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as num,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as RoundModel?,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TransactionItemModel implements _TransactionItemModel {
  const _$_TransactionItemModel(
      {this.id,
      this.transactionId,
      required this.transactionDate,
      required this.description,
      required this.createUserId,
      required this.points,
      required this.transactionType,
      required this.account,
      required this.credit,
      required this.hours,
      this.round,
      required this.user});

  factory _$_TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      _$$_TransactionItemModelFromJson(json);

  @override
  final num? id;
  @override
  final num? transactionId;
  @override
  final DateTime transactionDate;
  @override
  final String description;
  @override
  final num createUserId;
  @override
  final double points;
  @override
  final TransactionType transactionType;
  @override
  final Account account;
  @override
  final num credit;
  @override
  final num hours;
  @override
  final RoundModel? round;
  @override
  final UserModel user;

  @override
  String toString() {
    return 'TransactionItemModel(id: $id, transactionId: $transactionId, transactionDate: $transactionDate, description: $description, createUserId: $createUserId, points: $points, transactionType: $transactionType, account: $account, credit: $credit, hours: $hours, round: $round, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TransactionItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createUserId, createUserId) ||
                other.createUserId == createUserId) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      transactionId,
      transactionDate,
      description,
      createUserId,
      points,
      transactionType,
      account,
      credit,
      hours,
      round,
      user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TransactionItemModelCopyWith<_$_TransactionItemModel> get copyWith =>
      __$$_TransactionItemModelCopyWithImpl<_$_TransactionItemModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TransactionItemModelToJson(
      this,
    );
  }
}

abstract class _TransactionItemModel implements TransactionItemModel {
  const factory _TransactionItemModel(
      {final num? id,
      final num? transactionId,
      required final DateTime transactionDate,
      required final String description,
      required final num createUserId,
      required final double points,
      required final TransactionType transactionType,
      required final Account account,
      required final num credit,
      required final num hours,
      final RoundModel? round,
      required final UserModel user}) = _$_TransactionItemModel;

  factory _TransactionItemModel.fromJson(Map<String, dynamic> json) =
      _$_TransactionItemModel.fromJson;

  @override
  num? get id;
  @override
  num? get transactionId;
  @override
  DateTime get transactionDate;
  @override
  String get description;
  @override
  num get createUserId;
  @override
  double get points;
  @override
  TransactionType get transactionType;
  @override
  Account get account;
  @override
  num get credit;
  @override
  num get hours;
  @override
  RoundModel? get round;
  @override
  UserModel get user;
  @override
  @JsonKey(ignore: true)
  _$$_TransactionItemModelCopyWith<_$_TransactionItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}
