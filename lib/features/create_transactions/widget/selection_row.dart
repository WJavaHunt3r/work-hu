import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

class SelectionRow extends ConsumerWidget {
  const SelectionRow({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
            child: Text("${user.lastname} ${user.firstname}", style: const TextStyle(fontWeight: FontWeight.w600))),
        Checkbox(
            value: user.points != 0,
            onChanged: (changed) => ref
                .read(createTransactionsDataProvider.notifier)
                .update(userId: user.id, points: changed ?? false ? 10 : 0))
      ],
    );
  }
}
