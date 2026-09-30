import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';
import 'package:work_hu/features/utils.dart';

import '../providers/users_camps_provider.dart';

class UserCampsPage extends BaseListPage {
  const UserCampsPage({super.key, super.title = "user_camps"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserCampPageState();
  }
}

class UserCampPageState extends PagedListPageState<UserCampsPage, UserCampModel, int, UserCampDataNotifier> {
  @override
  get provider => userCampDataProvider;

  @override
  Widget buildListTile(UserCampModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      title: Text(item.userModel.getFullName()),
      subtitle: Text(item.campModel.campName ?? ""),
      trailing: Text(Utils.creditFormatting(item.price)),
    );
  }
}
