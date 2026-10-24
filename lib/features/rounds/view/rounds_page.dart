import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/utils.dart';

class RoundsPage extends BaseListPage {
  const RoundsPage({super.key, super.title = "rounds_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundsPageState();
  }
}

class RoundsPageState extends PagedListPageState<RoundsPage, RoundModel, RoundFilter, RoundsDataNotifier> {
  @override
  Widget buildListTile(RoundModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      onTap: () async {
        final changed = await context.push<bool>("/admin/rounds/${item.id}");
        if (changed == true) notifier.reload();
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "${item.season.seasonYear} - ${Utils.getMonthFromDate(item.startDateTime, context)}"
              "${item.activeRound ? "" : " (${"rounds_inactive".i18n()})"}",
              style: item.activeRound ? null : TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Row(
            children: [
              Text(Utils.percentFormatting(item.localMyShareGoal)),
              const Text(" - "),
              Text(Utils.percentFormatting(item.myShareGoal)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) => FloatingActionButton(
    tooltip: "rounds_new".i18n(),
    onPressed: () async {
      final created = await context.push<bool>("/admin/rounds/new");
      if (created == true) notifier.reload();
    },
    child: const Icon(Icons.add),
  );

  @override
  get provider => roundDataProvider;
}
