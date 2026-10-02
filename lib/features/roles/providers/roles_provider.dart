import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/roles/data/api/roles_api.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';
import 'package:work_hu/features/roles/data/repository/roles_repository.dart';

final rolesApiProvider = Provider<RolesApi>((ref) => RolesApi());

final rolesRepoProvider = Provider<RolesRepository>((ref) => RolesRepository(ref.read(rolesApiProvider)));

/// Roles have no filter; the list is small and arrives as a single page.
class NoFilter {
  const NoFilter();
}

final rolesDataProvider = StateNotifierProvider.autoDispose<RolesDataNotifier, PagedState<AppRoleModel, NoFilter>>(
  (ref) => RolesDataNotifier(ref.read(rolesRepoProvider)),
);

/// Names of all permissions, for the role editor.
final permissionNamesProvider = FutureProvider.autoDispose<List<String>>(
  (ref) => ref.read(rolesRepoProvider).getPermissions(),
);

/// All roles, for assigning them to a user.
final allRolesProvider = FutureProvider.autoDispose<List<AppRoleModel>>(
  (ref) async => (await ref.read(rolesRepoProvider).getRoles()).content,
);

class RolesDataNotifier extends PagedListNotifier<AppRoleModel, NoFilter> {
  RolesDataNotifier(this.repository) : super(const ListQuery(filter: NoFilter()));

  final RolesRepository repository;

  @override
  Future<PaginatedResponse<AppRoleModel>> fetch(ListQuery<NoFilter> query, int page) => repository.getRoles();

  Future<void> deleteRole(num id) async {
    await executeApiCall(
      () => repository.deleteRole(id),
      onSuccess: (_) async => removeItems((role) => role.id == id),
      onError: (message) async => showApiError(message),
    );
  }
}
