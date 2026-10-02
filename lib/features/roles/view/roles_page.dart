import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';

class RolesPage extends BaseListPage {
  const RolesPage({super.key, super.title = "roles_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => RolesPageState();
}

class RolesPageState extends PagedListPageState<RolesPage, AppRoleModel, NoFilter, RolesDataNotifier> {
  @override
  get provider => rolesDataProvider;

  @override
  Widget buildListTile(AppRoleModel item, int index) {
    return BaseListTile(
      index: index,
      isLast: index == items.length - 1,
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        "roles_summary".i18n(["${item.permissions.length}", "${item.userCount}"]),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
      onTap: () => _edit(item),
    );
  }

  /// Built-in roles stay; roles that still have users are refused by the backend with a readable message.
  @override
  bool canDelete(AppRoleModel item) => !item.isBuiltIn;

  @override
  void onDelete(AppRoleModel item) => notifier.deleteRole(item.id!);

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(onPressed: () => _edit(null), child: const Icon(Icons.add));

  void _edit(AppRoleModel? role) =>
      context.push("/admin/roles/edit", extra: role).then((saved) => saved == true ? notifier.reload() : null);
}
