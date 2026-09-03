import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';

class TransactionDetailsCard extends ConsumerWidget {
  const TransactionDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseContainer(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        children: [
          BaseTextFormField(
            controller: ref.watch(createTransactionsDataProvider.notifier).dateController,
            labelText: "create_transaction_transaction_date",
            suffix: IconButton(
              onPressed: () => _selectDate(context, ref),
              icon: const Icon(Icons.calendar_month),
            ),
          ),
          SizedBox(height: 5.sp),
          BaseTextFormField(
            controller: ref.watch(createTransactionsDataProvider.notifier).descriptionController,
            labelText: "create_transaction_description",
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      ref.watch(createTransactionsDataProvider.notifier).dateController.text = picked.toString();
    }
  }
}
