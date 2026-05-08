import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/top_ups/providers/top_ups_provider.dart';

import '../data/state/top_ups_state.dart';

class TopUpsPage extends BaseListPage {
  const TopUpsPage({
    super.key,
  }) : super(title: 'top_ups_title');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TopUpsPageState();
  }
}

class TopUpsPageState extends BaseListPageState<TopUpsPage, TopUpsState, TopUpsDataNotifier> {
  @override
  Widget buildListTiles(item) {
    return ListTile(
      // leading: const CircleAvatar(
      //   backgroundColor: Colors.greenReplacement, // Custom green
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
      title: Text(
        item.description,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        DateFormat('MMM dd, yyyy • HH:mm').format(item.createdAt),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '+ ${item.amount.toString()} Ft',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            'Bal: ${item.balanceAfter.toString()} Ft',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<TopUpsDataNotifier, TopUpsState> get provider => topUpsDataProvider;

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.topUps;

  @override
  BaseListState get listStatus => state.listStatus;
}
