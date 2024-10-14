import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/activity_items/data/model/activity_items_model.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/activity_items/widgets/activity_details_panel.dart';
import 'package:work_hu/features/utils.dart';

class ActivityItemsLayout extends BasePage {
  ActivityItemsLayout(
      {required this.activityId, super.key, super.title = "activity_items_registrations", super.isListView = true});

  final num activityId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(activityItemsDataProvider).modelState == ModelState.empty
        ? ref.watch(activityItemsDataProvider.notifier).getActivityItems(activityId: activityId)
        : null);
    var items = ref.watch(activityItemsDataProvider).activityItems;
    var activity = items.isNotEmpty ? items.first.activity : null;
    return Stack(children: [
      Column(children: [
        activity == null
            ? const SizedBox()
            : ActivityDetailsPanel(activity, items.map((e) => e.hours).reduce((a, b) => a + b)),
        Expanded(
            child: BaseListView(
          itemBuilder: (BuildContext context, int index) {
            var current = items[index];
            return current.activity?.registeredInApp ?? false || current.activity!.registeredInMyShare
                ? listItem(items, context, index, ref)
                : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) =>
                        ref.read(activityItemsDataProvider.notifier).deleteActivityItem(current.id!, index),
                    dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                    child: listItem(items, context, index, ref));
          },
          itemCount: ref.watch(activityItemsDataProvider).activityItems.length,
          shadowColor: Colors.transparent,
          cardBackgroundColor: Colors.transparent,
          children: const [],
        ))
      ]),
      Positioned(
        bottom: 25.sp,
        left: 5.sp,
        child: FloatingActionButton(
            child: const Image(
              image: AssetImage("assets/img/myshare-logo.png"),
              fit: BoxFit.fitWidth,
            ),
            onPressed: () => ref.watch(activityItemsDataProvider.notifier).createCreditCsv()),
      ),
      ref.watch(activityItemsDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(activityItemsDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(activityItemsDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  Widget listItem(List<ActivityItemsModel> items, BuildContext context, int index, WidgetRef ref) {
    var current = items[index];
    var date = current.activity!.activityDateTime;
    var dateString = Utils.dateToString(date);
    return ListCard(
        isLast: items.length - 1 == index,
        index: index,
        child: ListTile(
          onTap: () {},
          trailing: Text(
            "${current.hours.toString()} ${Utils.getTransactionTypeText(TransactionType.HOURS, false)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          title: Row(
            children: [
              Text(current.user.getFullName(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Text(dateString),
        ));
  }

// @override
// Widget? createActionButton(BuildContext context, WidgetRef ref) {
//   return FloatingActionButton(
//     heroTag: UniqueKey(),
//     onPressed: () => ref.watch(activityItemsDataProvider.notifier).createActivityXlsx(),
//     child: const Icon(Icons.download),
//   );
// }
}
