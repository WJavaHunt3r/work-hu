import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';

class SelectionRow extends ConsumerWidget {
  const SelectionRow({required this.id, required this.name, super.key});

  final num id;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
        Checkbox(
            value: ref
                    .watch(createTransactionsDataProvider)
                    .transactionItems
                    .where((element) => element.userId == id)
                    .first
                    .points !=
                0,
            onChanged: (changed) =>
                ref.read(createTransactionsDataProvider.notifier).update(userId: id, points: changed ?? false ? 10 : 0))
      ],
    );
  }
}
