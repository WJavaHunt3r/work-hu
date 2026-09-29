import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/user_fra_kare_week/data/model/user_fra_kare_week_model.dart';
import 'package:work_hu/features/user_fra_kare_week/data/state/user_fra_kare_week_state.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/widgets/selection_row.dart';

class UserFraKareWeekPage extends BaseListPage {
  UserFraKareWeekPage({required this.weekNumber, super.key, super.title = "admin_user_fra_kare_week"})
    : super(titleArgs: ["$weekNumber."]);

  final num weekNumber;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserFraKareWeekPageState();
  }
}

class UserFraKareWeekPageState
    extends BaseListPageState<UserFraKareWeekPage, UserFraKareWeekState, UserFraKareWeekDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    super.postInit(ref);
    ref.read(userFraKareWeekDataProvider.notifier).setWeekNumber(widget.weekNumber);
  }

  @override
  Widget buildListTile(item) {
    item as UserFraKareWeekModel;
    var index = items.indexOf(item);
    return SelectionRow(fraKareWeek: item, isLast: index == items.length - 1, index: index);
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 8.sp, top: 4.sp),
        child: TextButton(
          onPressed: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ConfirmAlertDialog(
                title: "user_fra_fare_week_save".i18n(),
                onConfirm: () {
                  context.pop();
                  ref.read(userFraKareWeekDataProvider.notifier).saveUserFraKareWeeks();
                },
                content: Text("user_fra_fare_week_save_question".i18n(), textAlign: TextAlign.center),
              );
            },
          ),
          style: ButtonStyle(
            side: WidgetStateBorderSide.resolveWith((states) => BorderSide(color: AppColors.primary, width: 2.sp)),
            backgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
          child: Text(
            "user_fra_fare_week_save".i18n(),
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.streaks;

  @override
  BaseListState get listStatus => state.listState;

  @override
  StateNotifierProvider<UserFraKareWeekDataNotifier, UserFraKareWeekState> get provider => userFraKareWeekDataProvider;
}
