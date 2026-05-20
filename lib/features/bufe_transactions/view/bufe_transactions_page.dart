import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/icon_box.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe_transaction_items/view/bufe_transaction_items_page.dart';
import 'package:work_hu/features/bufe_transactions/data/state/bufe_transactions_state.dart';
import 'package:work_hu/features/bufe_transactions/providers/bufe_transactions_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/widgets/base_list_item.dart';

class BufeTransactionsPage extends BaseListPage {
  const BufeTransactionsPage({
    super.key,
  }) : super(title: 'bufe_transactions_title');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BufeTransactionsPageState();
  }
}

class BufeTransactionsPageState
    extends BaseListPageState<BufeTransactionsPage, BufeTransactionsState, BufeTransactionsDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as OrderEntry;
    var theme = Theme.of(context);
    var index = items.indexOf(item);
    final locale = ref.watch(localeProvider).value?.countryCode ?? 'en_US';
    // 2. Use the locale in the DateFormat constructor
    return BaseListTile(
      leading: IconBox(icon: item.locationName == "Büfé" ? Icons.coffee_outlined : Icons.shopping_bag_outlined),
      title: Text(item.locationName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(Utils.dateFormating(item.date, locale), style: theme.textTheme.bodySmall),
      trailing: Text("- ${Utils.creditFormatting(item.total)}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      isLast: index == state.orders.length - 1,
      index: index,
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return BufeTransactionItemsPage(items: item.orderItems);
          }),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<BufeTransactionsDataNotifier, BufeTransactionsState> get provider =>
      bufeTransactionsDataProvider;

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.orders;

  @override
  BaseListState get listStatus => state.listStatus;
}
