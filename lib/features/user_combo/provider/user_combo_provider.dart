import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/user_combo/data/state/user_combo_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final userComboDataProvider =
    StateNotifierProvider<UserComboDataNotifier, UserComboState>((ref) => UserComboDataNotifier(ref.read(usersRepoProvider)));

class UserComboDataNotifier extends BaseDataNotifier<UserComboState> implements ListApiProvider<UserFilter> {
  UserComboDataNotifier(
    this.usersRepository,
  ) : super(const UserComboState());

  final UsersRepository usersRepository;
  final Map<String, List<UserComboModel>> _cache = {};

  @override
  Future<List<UserComboModel>> list({UserFilter? filter, int? page, int? size, List<String>? sort}) async {
    // var cacheKey = filter.toString();
    // if (_cache.containsKey(cacheKey)) {
    //   var list = _cache[cacheKey]!;
    //   return list;
    // }
    var sort = SortBuilder()
      ..add("lastname", descending: false)
      ..add("firstname", descending: false);
    state = state.copyWith(filter: filter ?? state.filter);
    try {
      var result = await usersRepository.fetchByQuery(
          filter: filter ?? state.filter, page: page, size: size, sort: sort);
      // _cache[cacheKey] = result.content;

      return result.content;
    } catch (e) {
      return [];
    }
  }

  @override
  UserComboState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }

  Future<UserComboModel?> getUser({required num id}) async {
    var result = await executeApiCall<UserModel>(
      () => usersRepository.getUserById(id),
    );

    if (result != null) {
      var data = result as UserModel;
      return UserComboModel(
          id: data.id,
          comboText: "${data.getFullName()} - ${data.getAge().toInt()}",
          firstname: data.firstname,
          lastname: data.lastname,
          age: data.getAge().toInt(),
          churchName: "");
    }
    return null;
  }
}
