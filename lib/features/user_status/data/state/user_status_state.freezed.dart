// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_status_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserStatusState {
  List<UserModel> get users => throw _privateConstructorUsedError;
  num get selectedTeamId => throw _privateConstructorUsedError;
  OrderByType get selectedOrderType => throw _privateConstructorUsedError;
  ModelState get modelState => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserStatusStateCopyWith<UserStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatusStateCopyWith<$Res> {
  factory $UserStatusStateCopyWith(
          UserStatusState value, $Res Function(UserStatusState) then) =
      _$UserStatusStateCopyWithImpl<$Res, UserStatusState>;
  @useResult
  $Res call(
      {List<UserModel> users,
      num selectedTeamId,
      OrderByType selectedOrderType,
      ModelState modelState,
      String message});
}

/// @nodoc
class _$UserStatusStateCopyWithImpl<$Res, $Val extends UserStatusState>
    implements $UserStatusStateCopyWith<$Res> {
  _$UserStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? selectedTeamId = null,
    Object? selectedOrderType = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      selectedTeamId: null == selectedTeamId
          ? _value.selectedTeamId
          : selectedTeamId // ignore: cast_nullable_to_non_nullable
              as num,
      selectedOrderType: null == selectedOrderType
          ? _value.selectedOrderType
          : selectedOrderType // ignore: cast_nullable_to_non_nullable
              as OrderByType,
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
abstract class _$$_UserStatusStateCopyWith<$Res>
    implements $UserStatusStateCopyWith<$Res> {
  factory _$$_UserStatusStateCopyWith(
          _$_UserStatusState value, $Res Function(_$_UserStatusState) then) =
      __$$_UserStatusStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> users,
      num selectedTeamId,
      OrderByType selectedOrderType,
      ModelState modelState,
      String message});
}

/// @nodoc
class __$$_UserStatusStateCopyWithImpl<$Res>
    extends _$UserStatusStateCopyWithImpl<$Res, _$_UserStatusState>
    implements _$$_UserStatusStateCopyWith<$Res> {
  __$$_UserStatusStateCopyWithImpl(
      _$_UserStatusState _value, $Res Function(_$_UserStatusState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? selectedTeamId = null,
    Object? selectedOrderType = null,
    Object? modelState = null,
    Object? message = null,
  }) {
    return _then(_$_UserStatusState(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      selectedTeamId: null == selectedTeamId
          ? _value.selectedTeamId
          : selectedTeamId // ignore: cast_nullable_to_non_nullable
              as num,
      selectedOrderType: null == selectedOrderType
          ? _value.selectedOrderType
          : selectedOrderType // ignore: cast_nullable_to_non_nullable
              as OrderByType,
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

class _$_UserStatusState extends _UserStatusState {
  const _$_UserStatusState(
      {final List<UserModel> users = const [],
      this.selectedTeamId = 0,
      this.selectedOrderType = OrderByType.NAME,
      this.modelState = ModelState.empty,
      this.message = ""})
      : _users = users,
        super._();

  final List<UserModel> _users;
  @override
  @JsonKey()
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey()
  final num selectedTeamId;
  @override
  @JsonKey()
  final OrderByType selectedOrderType;
  @override
  @JsonKey()
  final ModelState modelState;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'UserStatusState(users: $users, selectedTeamId: $selectedTeamId, selectedOrderType: $selectedOrderType, modelState: $modelState, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserStatusState &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.selectedTeamId, selectedTeamId) ||
                other.selectedTeamId == selectedTeamId) &&
            (identical(other.selectedOrderType, selectedOrderType) ||
                other.selectedOrderType == selectedOrderType) &&
            (identical(other.modelState, modelState) ||
                other.modelState == modelState) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      selectedTeamId,
      selectedOrderType,
      modelState,
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserStatusStateCopyWith<_$_UserStatusState> get copyWith =>
      __$$_UserStatusStateCopyWithImpl<_$_UserStatusState>(this, _$identity);
}

abstract class _UserStatusState extends UserStatusState {
  const factory _UserStatusState(
      {final List<UserModel> users,
      final num selectedTeamId,
      final OrderByType selectedOrderType,
      final ModelState modelState,
      final String message}) = _$_UserStatusState;
  const _UserStatusState._() : super._();

  @override
  List<UserModel> get users;
  @override
  num get selectedTeamId;
  @override
  OrderByType get selectedOrderType;
  @override
  ModelState get modelState;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_UserStatusStateCopyWith<_$_UserStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}
