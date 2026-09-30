import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/framework/base_components/base_page_components/base_list_page.dart';

class UsersPage extends BaseListPage {
  const UsersPage({super.key, super.title = "users_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UsersPageState();
  }
}

class UsersPageState extends PagedListPageState<UsersPage, UserComboModel, UserFilter, UsersDataNotifier> {
  @override
  Widget build(BuildContext context) {
    // Keeps the detail state alive for the dialog, and reports its errors, which the base page doesn't.
    ref.listen(userDetailProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(UserComboModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      title: Text(item.getFullName()),
      onTap: () {
        ref.read(userDetailProvider.notifier).getUser(item.id);
        showGeneralDialog(
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Theme.of(context).colorScheme.primary,
          transitionDuration: const Duration(milliseconds: 200),
          context: context,
          pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
            return UserDetails();
          },
        ).then((value) => value == true ? notifier.reload() : null);
      },
    );
  }

  @override
  get provider => usersDataProvider;
}
