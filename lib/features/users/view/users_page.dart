import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/users/data/state/users_state.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';

import '../../../app/framework/base_components/base_page_components/base_list_page.dart';

class UsersPage extends BaseListPage {
  const UsersPage({super.key, super.title = "users_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UsersPageState();
  }
}

class UsersPageState extends BaseListPageState<UsersPage, UsersState, UsersDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as UserComboModel;
    return BaseListTile(
      isLast: items.indexOf(item) == items.length - 1,
      index: items.indexOf(item),
      title: Text(item.getFullName()),
      onTap: () {
        ref.read(usersDataProvider.notifier).getUser(item.id);
        showGeneralDialog(
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Theme.of(context).colorScheme.primary,
            transitionDuration: const Duration(milliseconds: 200),
            context: context,
            pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return UserDetails();
            }).then((value) => value == true ? ref.watch(usersDataProvider.notifier).list() : null);
      },
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<UserComboModel> get items => state.users;

  @override
  BaseListState get listStatus => state.listState;

  @override
  get provider => usersDataProvider;
}
