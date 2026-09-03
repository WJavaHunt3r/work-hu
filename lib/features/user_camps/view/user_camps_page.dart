import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';

import '../data/state/user_camp_state.dart';
import '../providers/users_camps_provider.dart';

class UserCampsPage extends BaseListPage {
  const UserCampsPage({super.key, super.title = "user_camps"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserCampPageState();
  }
}

class UserCampPageState extends BaseListPageState<UserCampsPage, UserCampState, UserCampDataNotifier> {
  @override
  AutoDisposeStateNotifierProvider<UserCampDataNotifier, UserCampState> get provider => userCampDataProvider;

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<UserCampModel> get items => state.userCamps;

  @override
  BaseListState get listStatus => state.listState;
}
