import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/data/state/users_state.dart';
import 'package:work_hu/features/utils.dart';

final usersApiProvider = Provider<UsersApi>((ref) => UsersApi());

final usersRepoProvider = Provider<UsersRepository>((ref) => UsersRepository(ref.read(usersApiProvider)));

final usersDataProvider = StateNotifierProvider.autoDispose<UsersDataNotifier, UsersState>(
    (ref) => UsersDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider)));

class UsersDataNotifier extends StateNotifier<UsersState> {
  UsersDataNotifier(this.usersRepository, this.currentUser) : super(const UsersState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;

  Future<void> getUsers() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.getUsers(null, true).then((value) {
        value.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
        state = state.copyWith(users: value, filtered: value, modelState: ModelState.success);
      });
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> resetUserPassword(num userId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.resetPassword(userId, currentUser!.id);
      state = state.copyWith(modelState: ModelState.success);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> saveUser() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var updatedUser = await usersRepository.updateUser(currentUser!.id, state.selectedUser!);
      state = state.copyWith(selectedUser: updatedUser, modelState: ModelState.success);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void updateCurrentUser(UserModel user) {
    state = state.copyWith(selectedUser: user);
  }

  Future<void> filterUsers(String filter) async {
    var users = state.users;
    state = state.copyWith(
        filtered: users
            .where((user) =>
                Utils.changeSpecChars(user.firstname.toLowerCase())
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
                Utils.changeSpecChars(user.lastname.toLowerCase())
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
                Utils.changeSpecChars("${user.lastname.toLowerCase()} ${user.firstname.toLowerCase()}")
                    .startsWith(Utils.changeSpecChars(filter.toLowerCase())))
            .toList());
  }

  Future<void> downloadUserInfo() async {}

  Future<void> uploadUserInfo() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true,
      );

      if (pickedFile != null) {
        var file = pickedFile.files.first;

        final input = utf8.decode(file.bytes!);
        final fields = const CsvToListConverter().convert(input);
        var rowNb = 0;
        for (var row in fields) {
          if (rowNb != 0) {
            var field = row[0].split(";");
            try {
              var user = await usersRepository.getUserById(num.tryParse(field[0]) ?? 0);
              var email = field[6].toString().isNotEmpty ? field[6] : null;
              var phoneNumber = field[6].toString().isNotEmpty
                  ? num.tryParse(field[5].toString().substring(1).replaceAll(" ", "")) ?? 0
                  : 0;

              var newUser = user.copyWith(email: email, phoneNumber: phoneNumber == 0 ? null : phoneNumber);

              await usersRepository.updateUser(currentUser!.id, newUser);
            } catch (e) {
              log(row[0]);
            }
          }
          rowNb++;
        }
      }
      state = state.copyWith(modelState: ModelState.success);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: "Not supported: ${e.toString()}");
    }
  }
}
