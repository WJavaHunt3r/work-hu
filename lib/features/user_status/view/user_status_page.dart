import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/features/round_filter_chip/providers/round_filter_chip_provider.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/state/user_status_state.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/models/mode_state.dart';
import '../../../app/widgets/base_list_item.dart';

class UserStatusPage extends BaseListPage {
  const UserStatusPage({super.key, super.title = "admin_myshare_status"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserStatusPageState();
  }
}

class UserStatusPageState extends BaseListPageState<UserStatusPage, UserStatusState, UserStatusDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as UserStatusModel;
    var index = items.indexOf(item);
    var userStatus = item.status * 100;

    var toOnTrack = item.toOnTrack;

    var isLast = index == items.length - 1;
    return BaseListTile(
      isLast: isLast,
      index: index,
      minVerticalPadding: 0,
      title: Text(
        item.name,
      ),
      leading: item.onTrack
          ? Icon(
              Icons.done_outline,
              size: 24.sp,
            )
          : Icon(
              Icons.close_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 24.sp,
            ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.onTrack
              ? const Text(
                  "On Track",
                )
              : Text("myshare_status_to_be_ontrack_short".i18n([Utils.creditFormatting(toOnTrack)])),
          Text("myshare_status_goal".i18n([Utils.creditFormatting(item.goal)]))
        ],
      ),
      trailing: Text(
        "${Utils.percentFormat.format(userStatus)}%",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      tileColor:
          item.onTrack ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    return [
      BaseHeaderChip(
          label: "user_status_head_on_track", labelValue: () async => "${state.onTrackCount} / ${state.status.totalElements}"),
      BaseHeaderChip(
          label: "user_status_head_goal",
          labelValue: () async => "${ref.read(roundFilterChipDataProvider).currentRound?.localMyShareGoal}%")
    ];
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider).user!.isAdmin()
        ? [
            MaterialButton(
              onPressed: !status.modelState.isLoading ? () => ref.watch(provider.notifier).recalculate() : null,
              child: const Icon(Icons.refresh_outlined),
            ),
          ]
        : [];
  }

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
