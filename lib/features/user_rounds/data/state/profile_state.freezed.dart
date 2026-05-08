// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileState {
  List<UserModel> get children => throw _privateConstructorUsedError;
  List<UserStatusModel> get statuses => throw _privateConstructorUsedError;
  List<UserRoundModel> get userRounds => throw _privateConstructorUsedError;
  BaseState get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call(
      {List<UserModel> children,
      List<UserStatusModel> statuses,
      List<UserRoundModel> userRounds,
      BaseState status});

  $BaseStateCopyWith<$Res> get status;
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? children = null,
    Object? statuses = null,
    Object? userRounds = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      statuses: null == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<UserStatusModel>,
      userRounds: null == userRounds
          ? _value.userRounds
          : userRounds // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BaseState,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BaseStateCopyWith<$Res> get status {
    return $BaseStateCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
          _$ProfileStateImpl value, $Res Function(_$ProfileStateImpl) then) =
      __$$ProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> children,
      List<UserStatusModel> statuses,
      List<UserRoundModel> userRounds,
      BaseState status});

  @override
  $BaseStateCopyWith<$Res> get status;
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
      _$ProfileStateImpl _value, $Res Function(_$ProfileStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? children = null,
    Object? statuses = null,
    Object? userRounds = null,
    Object? status = null,
  }) {
    return _then(_$ProfileStateImpl(
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      statuses: null == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<UserStatusModel>,
      userRounds: null == userRounds
          ? _value._userRounds
          : userRounds // ignore: cast_nullable_to_non_nullable
              as List<UserRoundModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BaseState,
    ));
  }
}

/// @nodoc

class _$ProfileStateImpl extends _ProfileState {
  const _$ProfileStateImpl(
      {final List<UserModel> children = const [],
      final List<UserStatusModel> statuses = const [],
      final List<UserRoundModel> userRounds = const [],
      this.status = const BaseState()})
      : _children = children,
        _statuses = statuses,
        _userRounds = userRounds,
        super._();

  final List<UserModel> _children;
  @override
  @JsonKey()
  List<UserModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  final List<UserStatusModel> _statuses;
  @override
  @JsonKey()
  List<UserStatusModel> get statuses {
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statuses);
  }

  final List<UserRoundModel> _userRounds;
  @override
  @JsonKey()
  List<UserRoundModel> get userRounds {
    if (_userRounds is EqualUnmodifiableListView) return _userRounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userRounds);
  }

  @override
  @JsonKey()
  final BaseState status;

  @override
  String toString() {
    return 'ProfileState(children: $children, statuses: $statuses, userRounds: $userRounds, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality()
                .equals(other._userRounds, _userRounds) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_children),
      const DeepCollectionEquality().hash(_statuses),
      const DeepCollectionEquality().hash(_userRounds),
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);
}

abstract class _ProfileState extends ProfileState {
  const factory _ProfileState(
      {final List<UserModel> children,
      final List<UserStatusModel> statuses,
      final List<UserRoundModel> userRounds,
      final BaseState status}) = _$ProfileStateImpl;
  const _ProfileState._() : super._();

  @override
  List<UserModel> get children;
  @override
  List<UserStatusModel> get statuses;
  @override
  List<UserRoundModel> get userRounds;
  @override
  BaseState get status;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
