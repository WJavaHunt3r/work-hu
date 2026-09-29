import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';
import 'package:work_hu/features/fra_kare_week/data/state/fra_kare_week_state.dart';
import 'package:work_hu/features/fra_kare_week/providers/fra_kare_week_provider.dart';
import 'package:work_hu/features/utils.dart';

class FraKareWeekPage extends BaseListPage {
  const FraKareWeekPage({super.key, super.title = "admin_fra_kare_weeks"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return FraKareWeekPageState();
  }
}

class FraKareWeekPageState extends BaseListPageState<FraKareWeekPage, FraKareWeekState, FraKareWeekDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as FraKareWeekModel;
    var index = items.indexOf(item);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      enabled: !item.locked,
      onTap: () => context.push("/admin/fraKareWeeks/${item.weekNumber}"),
      title: Text("fra_kare_week_weekNumber".i18n([item.weekNumber.toString()])),
      subtitle: Text("${Utils.dateToString(item.weekStartDate)} - ${Utils.dateToString(item.weekEndDate)}"),
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.weeks;

  @override
  BaseListState get listStatus => state.listState;

  @override
  StateNotifierProvider<FraKareWeekDataNotifier, FraKareWeekState> get provider => fraKareWeekDataProvider;
}
