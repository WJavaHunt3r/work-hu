import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/data/state/users_state.dart';
import 'package:work_hu/features/utils.dart';

final usersApiProvider = Provider<UsersApi>((ref) => UsersApi());

final usersRepoProvider = Provider<UsersRepository>((ref) => UsersRepository(ref.read(usersApiProvider)));

final usersDataProvider = StateNotifierProvider.autoDispose<UsersDataNotifier, UsersState>(
    (ref) => UsersDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider).user));

class UsersDataNotifier extends BaseDataNotifier<UsersState> implements ListApiProvider<UserFilter> {
  UsersDataNotifier(this.usersRepository, this.currentUser) : super(const UsersState()) {
    list();
  }

  final UsersRepository usersRepository;
  final UserModel? currentUser;

  @override
  Future<void> list({UserFilter? filter, int? page, int? size, List<String>? sort}) async {
    // var cacheKey = filter.toString();
    // if (_cache.containsKey(cacheKey)) {
    //   var list = _cache[cacheKey]!;
    //   return list;
    // }
    var sort = SortBuilder()
      ..add("lastname", descending: false)
      ..add("firstname", descending: false);
    // _cache[cacheKey] = result.content;
    await executeApiCall<PaginatedResponse<UserComboModel>>(
        () => usersRepository.fetchByQuery(
            filter: filter ?? state.filter,
            page: page ?? state.listState.number,
            size: size ?? state.listState.size,
            sort: sort), onSuccess: (data) async {
      state = state.copyWith(
          users: page == 0 ? data.content : [...state.users, ...data.content],
          listState: state.listState
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> resetUserPassword(num userId) async {
    state = state.copyWith(modelState: ModelState.loading);
    try {
      await usersRepository.resetPassword(userId, currentUser!.id);
      state = state.copyWith(modelState: ModelState.success);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> saveUser() async {
    state = state.copyWith(modelState: ModelState.loading);
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
    state = state.copyWith();
  }

  Future<void> downloadUserInfo() async {}

  Future<void> uploadUserInfo() async {
    state = state.copyWith(modelState: ModelState.loading);
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
              var phoneNumber =
                  field[6].toString().isNotEmpty ? num.tryParse(field[5].toString().substring(1).replaceAll(" ", "")) ?? 0 : 0;

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

  @override
  UsersState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));

  }

  Future<void> getUser(num id)async {
    state = state.copyWith(selectedUser: null);
    await executeApiCall<UserModel>(()=> usersRepository.getUserById(id), onSuccess: (user)async{
      state = state.copyWith(selectedUser: user);
    });
  }
}
