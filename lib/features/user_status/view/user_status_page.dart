import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/features/user_status/data/model/user_status_filter.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
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

class UserStatusPageState
    extends PagedListPageState<UserStatusPage, UserStatusModel, UserStatusFilter, UserStatusDataNotifier> {
  @override
  Widget build(BuildContext context) {
    // The base page only reports errors of the list provider.
    ref.listen(userStatusHeadProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(UserStatusModel item, int index) {
    var userStatus = item.status * 100;

    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      minVerticalPadding: 0,
      title: Text(item.name),
      leading: item.localOnTrack
          ? Icon(Icons.done_outline, size: 24.sp)
          : Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.error, size: 24.sp),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.localOnTrack
              ? const Text("On Track")
              : Text("myshare_status_to_be_local_ontrack_short".i18n([Utils.creditFormatting(item.toLocalOnTrack)])),
          item.onTrack
              ? const Text("On Track")
              : Text("myshare_status_to_be_ontrack_short".i18n([Utils.creditFormatting(item.toOnTrack)])),
          Text(
            "${"myshare_status_goal".i18n([Utils.creditFormatting(item.goal)])} - ${"myshare_status_status".i18n()}: ${Utils.creditFormatting(item.transactions)}",
          ),
        ],
      ),
      trailing: Text("${Utils.percentFormat.format(userStatus)}%", style: Theme.of(context).textTheme.bodyLarge),
      tileColor: item.localOnTrack
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    final headData = ref.watch(userStatusHeadProvider).headData;
    return [
      BaseHeaderChip(
        label: "user_status_head_on_track",
        labelValue: () async => "${headData.onTrackCount} / ${headData.goalCount}",
      ),
      BaseHeaderChip(label: "user_status_head_goal", labelValue: () async => "${headData.localMyShareGoal}%"),
    ];
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider).user!.isAdmin()
        ? [
            MaterialButton(
              onPressed: !ref.watch(userStatusHeadProvider).status.modelState.isLoading ? _recalculate : null,
              child: const Icon(Icons.refresh_outlined),
            ),
          ]
        : [];
  }

  Future<void> _recalculate() async {
    if (await ref.read(userStatusHeadProvider.notifier).recalculate()) notifier.reload();
  }

  @override
  get provider => userStatusDataProvider;
}
