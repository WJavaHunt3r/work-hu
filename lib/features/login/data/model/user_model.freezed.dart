// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  num get id => throw _privateConstructorUsedError;
  String get firstname => throw _privateConstructorUsedError;
  String get lastname => throw _privateConstructorUsedError;
  DateTime get birthDate => throw _privateConstructorUsedError;
  TeamModel? get team => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;
  num get myShareID => throw _privateConstructorUsedError;
  num get baseMyShareCredit => throw _privateConstructorUsedError;
  num get currentMyShareCredit => throw _privateConstructorUsedError;
  bool get changedPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {num id,
      String firstname,
      String lastname,
      DateTime birthDate,
      TeamModel? team,
      Role role,
      num myShareID,
      num baseMyShareCredit,
      num currentMyShareCredit,
      bool changedPassword});

  $TeamModelCopyWith<$Res>? get team;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstname = null,
    Object? lastname = null,
    Object? birthDate = null,
    Object? team = freezed,
    Object? role = null,
    Object? myShareID = null,
    Object? baseMyShareCredit = null,
    Object? currentMyShareCredit = null,
    Object? changedPassword = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      firstname: null == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String,
      lastname: null == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      team: freezed == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as TeamModel?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      myShareID: null == myShareID
          ? _value.myShareID
          : myShareID // ignore: cast_nullable_to_non_nullable
              as num,
      baseMyShareCredit: null == baseMyShareCredit
          ? _value.baseMyShareCredit
          : baseMyShareCredit // ignore: cast_nullable_to_non_nullable
              as num,
      currentMyShareCredit: null == currentMyShareCredit
          ? _value.currentMyShareCredit
          : currentMyShareCredit // ignore: cast_nullable_to_non_nullable
              as num,
      changedPassword: null == changedPassword
          ? _value.changedPassword
          : changedPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamModelCopyWith<$Res>? get team {
    if (_value.team == null) {
      return null;
    }

    return $TeamModelCopyWith<$Res>(_value.team!, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$_UserModelCopyWith(
          _$_UserModel value, $Res Function(_$_UserModel) then) =
      __$$_UserModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num id,
      String firstname,
      String lastname,
      DateTime birthDate,
      TeamModel? team,
      Role role,
      num myShareID,
      num baseMyShareCredit,
      num currentMyShareCredit,
      bool changedPassword});

  @override
  $TeamModelCopyWith<$Res>? get team;
}

/// @nodoc
class __$$_UserModelCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$_UserModel>
    implements _$$_UserModelCopyWith<$Res> {
  __$$_UserModelCopyWithImpl(
      _$_UserModel _value, $Res Function(_$_UserModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstname = null,
    Object? lastname = null,
    Object? birthDate = null,
    Object? team = freezed,
    Object? role = null,
    Object? myShareID = null,
    Object? baseMyShareCredit = null,
    Object? currentMyShareCredit = null,
    Object? changedPassword = null,
  }) {
    return _then(_$_UserModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      firstname: null == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String,
      lastname: null == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      team: freezed == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as TeamModel?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      myShareID: null == myShareID
          ? _value.myShareID
          : myShareID // ignore: cast_nullable_to_non_nullable
              as num,
      baseMyShareCredit: null == baseMyShareCredit
          ? _value.baseMyShareCredit
          : baseMyShareCredit // ignore: cast_nullable_to_non_nullable
              as num,
      currentMyShareCredit: null == currentMyShareCredit
          ? _value.currentMyShareCredit
          : currentMyShareCredit // ignore: cast_nullable_to_non_nullable
              as num,
      changedPassword: null == changedPassword
          ? _value.changedPassword
          : changedPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserModel extends _UserModel {
  const _$_UserModel(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.birthDate,
      this.team,
      required this.role,
      required this.myShareID,
      required this.baseMyShareCredit,
      required this.currentMyShareCredit,
      required this.changedPassword})
      : super._();

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserModelFromJson(json);

  @override
  final num id;
  @override
  final String firstname;
  @override
  final String lastname;
  @override
  final DateTime birthDate;
  @override
  final TeamModel? team;
  @override
  final Role role;
  @override
  final num myShareID;
  @override
  final num baseMyShareCredit;
  @override
  final num currentMyShareCredit;
  @override
  final bool changedPassword;

  @override
  String toString() {
    return 'UserModel(id: $id, firstname: $firstname, lastname: $lastname, birthDate: $birthDate, team: $team, role: $role, myShareID: $myShareID, baseMyShareCredit: $baseMyShareCredit, currentMyShareCredit: $currentMyShareCredit, changedPassword: $changedPassword)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.myShareID, myShareID) ||
                other.myShareID == myShareID) &&
            (identical(other.baseMyShareCredit, baseMyShareCredit) ||
                other.baseMyShareCredit == baseMyShareCredit) &&
            (identical(other.currentMyShareCredit, currentMyShareCredit) ||
                other.currentMyShareCredit == currentMyShareCredit) &&
            (identical(other.changedPassword, changedPassword) ||
                other.changedPassword == changedPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstname,
      lastname,
      birthDate,
      team,
      role,
      myShareID,
      baseMyShareCredit,
      currentMyShareCredit,
      changedPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      __$$_UserModelCopyWithImpl<_$_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final num id,
      required final String firstname,
      required final String lastname,
      required final DateTime birthDate,
      final TeamModel? team,
      required final Role role,
      required final num myShareID,
      required final num baseMyShareCredit,
      required final num currentMyShareCredit,
      required final bool changedPassword}) = _$_UserModel;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override
  num get id;
  @override
  String get firstname;
  @override
  String get lastname;
  @override
  DateTime get birthDate;
  @override
  TeamModel? get team;
  @override
  Role get role;
  @override
  num get myShareID;
  @override
  num get baseMyShareCredit;
  @override
  num get currentMyShareCredit;
  @override
  bool get changedPassword;
  @override
  @JsonKey(ignore: true)
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
