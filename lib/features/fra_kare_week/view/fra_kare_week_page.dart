import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';
import 'package:work_hu/features/fra_kare_week/providers/fra_kare_week_provider.dart';
import 'package:work_hu/features/utils.dart';

class FraKareWeekPage extends BaseListPage {
  const FraKareWeekPage({super.key, super.title = "admin_fra_kare_weeks"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return FraKareWeekPageState();
  }
}

class FraKareWeekPageState extends PagedListPageState<FraKareWeekPage, FraKareWeekModel, int, FraKareWeekDataNotifier> {
  @override
  Widget buildListTile(FraKareWeekModel item, int index) {
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
  get provider => fraKareWeekDataProvider;
}
