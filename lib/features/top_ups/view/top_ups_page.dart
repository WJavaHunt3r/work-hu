import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/icon_box.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/top_ups/providers/top_ups_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/widgets/base_list_item.dart';

class TopUpsPage extends BaseListPage {
  const TopUpsPage({super.key}) : super(title: 'top_ups_title');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TopUpsPageState();
  }
}

class TopUpsPageState extends PagedListPageState<TopUpsPage, TopUpEntry, num, TopUpsDataNotifier> {
  @override
  Widget buildListTile(TopUpEntry item, int index) {
    return BaseListTile(
      leading: IconBox(icon: item.type == "transfer" ? Icons.compare_arrows : Icons.payments_outlined),
      title: Text(
        item.type == "transfer" ? "top_ups_transfer".i18n() : "top_ups_topup".i18n(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(Utils.dateFormating(item.createdAt, ref.watch(localeProvider).value?.countryCode)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${item.amount > 0 ? "+" : ""}${Utils.creditFormatting(item.amount)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'Bal: ${Utils.creditFormatting(item.balanceAfter)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      isLast: index == items.length - 1,
      index: index,
    );
  }

  @override
  get provider => topUpsDataProvider;
}
