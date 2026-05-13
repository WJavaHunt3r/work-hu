import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:riverpod/src/state_notifier_provider.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/data/state/activity_state.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activities/widgets/actitivty_list_item.dart';
import 'package:work_hu/features/utils.dart';

class ActivitiesPage extends BaseListPage {
  const ActivitiesPage({super.key, super.title = "admin_activities"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ActivitiesPageState();
  }
}

class ActivitiesPageState extends BaseListPageState<ActivitiesPage, ActivityState, ActivityDataNotifier> {
  @override
  AutoDisposeStateNotifierProvider<ActivityDataNotifier, ActivityState> get provider => activityDataProvider;

  late List<DateTime> dates;

  @override
  void postInit(WidgetRef ref) {
    dates = createDates();
  }

  @override
  Widget buildListTile(item) {
    return ActivityListItem(
      isLast: false,
      index: items.indexOf(item),
      current: item,
      onIconPressed: () {
        showDialog(
            context: context,
            builder: (context) => BaseConfirmDialog(
                onConfirm: () {},
                title: !item.registeredInApp
                    ? "activities_register_confirm_title".i18n()
                    : !item.registeredInMyShare
                        ? "activities_confirm_register_in_myshare_title".i18n()
                        : item.registeredInMyShare && item.registeredInApp && !item.registeredInTeams
                            ? "activities_confirm_register_in_teams_title".i18n()
                            : "base_confirm_title".i18n(),
                content: !item.registeredInApp
                    ? "activities_confirm_activity_register_question".i18n()
                    : !item.registeredInMyShare
                        ? "activities_confirm_register_in_myshare_question".i18n()
                        : item.registeredInMyShare && item.registeredInApp && !item.registeredInTeams
                            ? "activities_confirm_register_in_teams_question".i18n()
                            : "base_confirm_question".i18n())).then((r) {
          if (r != null && r == true) {
            if (!item.registeredInApp) {
              ref.read(activityDataProvider.notifier).registerActivity(item.id!).then((r) => list());
            } else if (!item.registeredInMyShare && item.transactionType != TransactionType.POINT) {
              ref.read(activityDataProvider.notifier).putActivity(item.copyWith(registeredInMyShare: true)).then((r) => list());
            } else if (item.registeredInMyShare && item.registeredInApp && !item.registeredInTeams) {
              ref.read(activityDataProvider.notifier).registerActivityInTeams(item.id!).then((r) => list());
            }
          }
        });
      },
    );
  }

  @override
  Widget? buildListLayout(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var notRegistered = items.where((e) => !e.registeredInMyShare);

    var registered = items.where((e) => e.registeredInMyShare);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.sp),
        if (notRegistered.isNotEmpty) _buildNotRegistered(theme, buildListTiles(notRegistered.toList())),
        if (registered.isNotEmpty)
          Text('activities_registered'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.sp),
        ...buildListTiles(registered.toList())
      ],
    );
  }

  @override
  bool canDelete(item) {
    item as ActivityModel;
    return !item.registeredInMyShare && !item.registeredInApp && locator<UserProvider>().user!.isAdmin();
  }

  Widget _buildNotRegistered(ThemeData theme, List<dynamic> notRegistered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('activities_not_registered'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.sp),
        ...notRegistered,
      ],
    );
  }

  List<DateTime> createDates() {
    var dates = <DateTime>[];
    for (var i = DateTime.now().year; i >= 2024; i--) {
      var month = i != DateTime.now().year ? 12 : DateTime.now().month;
      for (var j = month; j >= 1; j--) {
        dates.add(DateTime(i, j, 1));
      }
    }

    return dates;
  }

  @override
  onDelete(e) {
    ref.read(provider.notifier).deleteActivity((e as ActivityModel).id!);
  }

  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    return [
      DialogFilterChip<DateTime>(
          label: "activity_reference_date",
          showDelete: false,
          labelValue: (date) =>
              "${date?.year ?? state.filter.referenceDate?.year} - ${Utils.getMonthFromDate(date ?? state.filter.referenceDate!, context)}",
          onDeleted: () => list(filter: state.filter.copyWith(referenceDate: null)),
          initialValue: state.filter.referenceDate,
          onItemSelected: (e) => list(filter: state.filter.copyWith(referenceDate: e)),
          children: () async => dates,
          title: (date) => Text("${date.year} - ${Utils.getMonthFromDate(date, context)}"))
    ];
  }

  @override
  List<dynamic> getFilters() {
    return const ActivityFilter().toJson().keys.toList();
  }

  @override
  List<ActivityModel> get items => state.activities;

  @override
  BaseListState get listStatus => state.status;

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            context.push("/profile/activities/createActivity").then((value) => value != null && value == true ? list() : null));
  }
}
