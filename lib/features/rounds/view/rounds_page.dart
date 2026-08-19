import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class RoundsPage extends BaseListPage {
  const RoundsPage({super.key, super.title = "rounds_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundsPageState();
  }
}

class RoundsPageState extends BaseListPageState<RoundsPage, RoundsState, RoundsDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as RoundModel;
    var index = items.indexOf(item);
    return BaseListTile(
      isLast: item == items.last,
      index: index,
      title: Text("${item.season.seasonYear} - ${Utils.getMonthFromDate(item.startDateTime, context)}"),
      trailing: Text(Utils.percentFormatting(item.myShareGoal)),
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.rounds;

  @override
  BaseListState get listStatus => state.status;

  @override
  get provider => roundDataProvider;
}
