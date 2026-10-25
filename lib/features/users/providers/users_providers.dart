import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/churches/church_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/features/roles/data/repository/roles_repository.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/data/state/user_detail_state.dart';

final usersApiProvider = Provider<UsersApi>((ref) => UsersApi());

final usersRepoProvider = Provider<UsersRepository>((ref) => UsersRepository(ref.read(usersApiProvider)));

final usersDataProvider = StateNotifierProvider.autoDispose<UsersDataNotifier, PagedState<UserComboModel, UserFilter>>(
  (ref) => UsersDataNotifier(ref.read(usersRepoProvider), ref.read(userDataProvider).user),
);

/// All churches, for the user list's filter and the church of a user.
final churchesProvider = FutureProvider.autoDispose<List<ChurchModel>>(
  (ref) => ref.read(usersRepoProvider).getChurches(),
);

final userDetailProvider = StateNotifierProvider.autoDispose<UserDetailNotifier, UserDetailState>(
  (ref) =>
      UserDetailNotifier(ref.read(usersRepoProvider), ref.read(rolesRepoProvider), ref.read(userDataProvider).user),
);

const usersByName = [SortOrder("lastname"), SortOrder("firstname")];

class UsersDataNotifier extends PagedListNotifier<UserComboModel, UserFilter> {
  UsersDataNotifier(this.usersRepository, this.currentUser)
    : super(const ListQuery(filter: UserFilter(churchId: 1), sort: usersByName));

  final UsersRepository usersRepository;
  final UserModel? currentUser;

  /// Search by name; the filter keeps the rest.
  Future<void> setKeyword(String text) {
    final keyword = text.trim();
    final filter = state.query.filter;
    if ((filter.keyword ?? "") == keyword) return Future.value();
    return setFilter(filter.copyWith(keyword: keyword.isEmpty ? null : keyword));
  }

  @override
  Future<PaginatedResponse<UserComboModel>> fetch(ListQuery<UserFilter> query, int page) =>
      usersRepository.fetchByQuery(query, page: page);

  Future<void> uploadUserInfo() async {
    await executeApiCall(() async {
      List<PlatformFile>? pickedFile = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

      if (pickedFile.isNotEmpty) {
        var file = pickedFile.first;

        final input = utf8.decode(await file.readAsBytes());
        final fields = Csv(autoDetect: false, dynamicTyping: true).decode(input);
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
      return true;
    });
  }
}

/// The user shown and edited in the user details dialog.
class UserDetailNotifier extends BaseDataNotifier<UserDetailState> {
  UserDetailNotifier(this.usersRepository, this.rolesRepository, this.currentUser) : super(const UserDetailState());

  final UsersRepository usersRepository;
  final RolesRepository rolesRepository;
  final UserModel? currentUser;

  /// Roles the user had when loaded, to tell whether the roles need saving.
  List<String> _loadedRoleNames = const [];
  num? _loadedChurchId;

  bool get canManageUsers => currentUser?.hasPermission(Permission.USER_MANAGE) ?? false;

  /// Roles are assigned separately from the profile, and only by users who may manage roles.
  bool get canManageRoles => currentUser?.hasPermission(Permission.ROLE_MANAGE) ?? false;

  Future<void> getUser(num id) async {
    state = state.copyWith(selectedUser: null);
    await executeApiCall<UserModel>(
      () => usersRepository.getUserById(id),
      onSuccess: (user) async {
        _loadedRoleNames = user.roleNames;
        _loadedChurchId = user.churchId;
        state = state.copyWith(selectedUser: user);
      },
    );
  }

  void updateCurrentUser(UserModel user) {
    state = state.copyWith(selectedUser: user);
  }

  /// Adds or removes one role of the edited user (saved with [saveUser]).
  void toggleRole(String roleName, bool assigned) {
    final user = state.selectedUser;
    if (user == null) return;
    final names = {...user.roleNames};
    assigned ? names.add(roleName) : names.remove(roleName);
    state = state.copyWith(selectedUser: user.copyWith(roleNames: names.toList()));
  }

  /// Saves the profile and, if they changed, the roles. Returns whether everything was saved.
  Future<bool> saveUser() async {
    final edited = state.selectedUser!;
    final saved = await executeApiCall<UserModel>(
      () => guardApi(() async {
        var user = await usersRepository.updateUser(currentUser!.id, edited);
        final rolesChanged =
            !(Set.of(edited.roleNames).difference(Set.of(_loadedRoleNames)).isEmpty &&
                Set.of(_loadedRoleNames).difference(Set.of(edited.roleNames)).isEmpty);
        if (canManageRoles && rolesChanged) {
          final roles = (await rolesRepository.getRoles()).content;
          final ids = roles.where((r) => edited.roleNames.contains(r.name)).map((r) => r.id!);
          user = await rolesRepository.setUserRoles(edited.id, ids);
        }
        if (canManageUsers && edited.churchId != _loadedChurchId) {
          user = await usersRepository.setUserChurch(edited.id, edited.churchId);
        }
        return user;
      }),
      onSuccess: (user) async {
        _loadedRoleNames = user.roleNames;
        _loadedChurchId = user.churchId;
        state = state.copyWith(selectedUser: user);
      },
      onError: (message) async => showApiError(message),
    );
    return saved != null;
  }

  /// Creates a user from the "add user" form; returns the result, or null (after showing the reason) when refused.
  Future<({UserModel user, bool emailSent})?> createUser(Map<String, dynamic> data) async {
    final created = await executeApiCall<({UserModel user, bool emailSent})>(
      () => usersRepository.createUser(data),
      onError: (message) async => showApiError(message),
    );
    return created as ({UserModel user, bool emailSent})?;
  }

  /// Deletes the edited user. Returns whether it is gone; otherwise the reason (e.g. the user has history) was shown.
  Future<bool> deleteUser() async {
    final id = state.selectedUser!.id;
    final deleted = await executeApiCall<bool>(
      () => guardApi(() async {
        await usersRepository.deleteUser(id);
        return true;
      }),
      onError: (message) async => showApiError(message),
    );
    return deleted == true;
  }

  /// E-mails the user a one-time link to set a new password (the backend's reason is shown when it can't, e.g. no
  /// e-mail address). Returns whether the mail went out.
  Future<bool> resetUserPassword(num userId) async {
    final sent = await executeApiCall<bool>(
      () => guardApi(() async {
        await usersRepository.resetPassword(userId, currentUser!.id);
        return true;
      }),
      onError: (message) async => showApiError(message),
    );
    return sent == true;
  }

  @override
  UserDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
