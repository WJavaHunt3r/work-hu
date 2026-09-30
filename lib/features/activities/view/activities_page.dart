import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_confirm_dialog.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/features/activities/data/model/activity_filter.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
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

class ActivitiesPageState
    extends PagedListPageState<ActivitiesPage, ActivityModel, ActivityFilter, ActivityDataNotifier> {
  @override
  get provider => activityDataProvider;

  final List<DateTime?> dates = createDates();

  static List<DateTime?> createDates() {
    var dates = <DateTime?>[];
    dates.add(null);
    for (var i = 2024; i <= DateTime.now().year; i++) {
      var month = i != DateTime.now().year ? 12 : DateTime.now().month;
      for (var j = 1; j <= month; j++) {
        dates.add(DateTime(i, j, 1));
      }
    }

    return dates.reversed.toList();
  }

  @override
  Widget buildListTile(ActivityModel item, int index) {
    return ActivityListItem(
      isLast: false,
      index: index,
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
                : "base_confirm_question".i18n(),
          ),
        ).then((r) {
          if (r == true) {
            if (!item.registeredInApp) {
              notifier.registerActivity(item.id!);
            } else if (!item.registeredInMyShare && item.transactionType != TransactionType.POINT) {
              notifier.putActivity(item.copyWith(registeredInMyShare: true));
            } else if (item.registeredInMyShare && item.registeredInApp && !item.registeredInTeams) {
              notifier.registerActivityInTeams(item.id!);
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
        if (notRegistered.isNotEmpty) _buildNotRegistered(theme, buildListTiles(notRegistered)),
        if (registered.isNotEmpty)
          Text(
            'activities_registered'.i18n(),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 16.sp),
        ...buildListTiles(registered),
      ],
    );
  }

  @override
  bool canDelete(ActivityModel item) =>
      !item.registeredInMyShare && !item.registeredInApp && ref.read(userDataProvider).user!.isAdmin();

  Widget _buildNotRegistered(ThemeData theme, List<Widget> notRegistered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'activities_not_registered'.i18n(),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.sp),
        ...notRegistered,
      ],
    );
  }

  @override
  void onDelete(ActivityModel item) => notifier.deleteActivity(item.id!);

  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    final filter = state.query.filter;
    return [
      DialogFilterChip<DateTime?>(
        label: "activity_reference_date",
        showDelete: false,
        labelValue: (date) =>
            "${date?.year ?? filter.referenceDate?.year} - ${Utils.getMonthFromDate(date ?? filter.referenceDate!, context)}",
        onDeleted: () => notifier.setFilter(filter.copyWith(referenceDate: null)),
        initialValue: filter.referenceDate,
        onItemSelected: (e) => notifier.setFilter(filter.copyWith(referenceDate: e)),
        children: () async => dates,
        title: (date) => date == null ? Text("") : Text("${date.year} - ${Utils.getMonthFromDate(date, context)}"),
      ),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () =>
          context.push("/profile/activities/createActivity").then((value) => value == true ? notifier.reload() : null),
    );
  }
}
