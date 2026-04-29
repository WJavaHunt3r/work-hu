import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/bufe/view/bufe_layout.dart';
import 'package:work_hu/features/bufe/widgets/account_balance.dart';

class BufePage extends LegacyBasePage {
  const BufePage({super.key, this.onTrack, required this.userId, super.title = "", super.isListView = true});

  final bool? onTrack;
  final num userId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return BufeLayout(
      onTrack: onTrack,
      userId: userId,
    );
  }

  @override
  PreferredSizeWidget? buildBottom(WidgetRef ref, BuildContext context) {
    var account = ref.watch(bufeDataProvider).account;
    return PreferredSize(
        preferredSize: Size(Size.infinite.width, 200),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: AccountBalance(
            name: account?.full_name ?? "",
            balance: account?.balance ?? 0,
            duappId: num.tryParse(account?.dukapp_id ?? "0") ?? 0,
            onTrack: onTrack,
          ),
        ));
  }
}
