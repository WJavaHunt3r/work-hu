import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/widgets/base_list_item.dart';
import '../widgets/base_filter_chip.dart';

class UserStatusPage extends BaseListPage {
  const UserStatusPage({super.key, super.title = "admin_myshare_status"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserStatusPageState();
  }
}

class UserStatusPageState extends BaseListPageState<UserStatusPage, UserStatusState, UserStatusDataNotifier> {
  @override
  Widget buildListTiles(item) {
    var index = items.indexOf(item);
    var userStatus = item.status * 100;

    var toOnTrack = item.toOnTrack;

    var isLast = index == items.length - 1;
    return BaseListTile(
      isLast: isLast,
      index: index,
      // onTap: () => showGeneralDialog(
      //     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //     barrierColor: AppColors.primary,
      //     transitionDuration: const Duration(milliseconds: 200),
      //     context: context,
      //     pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
      //       return MyShareStatusPage(
      //           userGoalRound: UserGoalUserRoundModel(userStatus: item, round: currentRound!));
      //     }),
      minVerticalPadding: 0,
      title: Text(
        item.name,
      ),
      subtitle: item.onTrack
          ? const Text(
              "On Track",
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("myshare_status_to_be_ontrack_short".i18n([Utils.creditFormatting(toOnTrack)])),
              ],
            ),
      trailing: Text(
        "${Utils.percentFormat.format(userStatus)}%",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      tileColor: item.onTrack ? AppColors.primary : null,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider).user!.isAdmin()
        ? [
            MaterialButton(
              onPressed: !status.modelState.isLoading ? () => ref.watch(userStatusDataProvider.notifier).recalculate() : null,
              child: const Icon(Icons.refresh_outlined),
            ),
          ]
        : [];
  }

  // @override
  // List<BaseFilterChip<dynamic>> buildFilterLayout(BuildContext context, WidgetRef ref) {
  //   return [
  //   BaseFilterChip<dynamic>(
  //     isSelected: ref.watch(userStatusDataProvider).selectedOrderType == OrderByType.NAME,
  //     title: "myshare_status_name".i18n(),
  //     onSelected: (bool selected) =>
  //         ref.watch(userStatusDataProvider.notifier).setSelectedOrderType(selected ? OrderByType.NAME : OrderByType.NONE),
  //   ),
  //   BaseFilterChip(
  //     isSelected: ref.watch(userStatusDataProvider).selectedOrderType == OrderByType.STATUS,
  //     title: "myshare_status_status".i18n(),
  //     onSelected: (bool selected) =>
  //         ref.watch(userStatusDataProvider.notifier).setSelectedOrderType(selected ? OrderByType.STATUS : OrderByType.NONE),
  //   ),
  //   ];
  // }
  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.userStatuses;

  @override
  BaseListState get listStatus => state.status;

  @override
  AutoDisposeStateNotifierProvider<UserStatusDataNotifier, UserStatusState> get provider => userStatusDataProvider;
}
