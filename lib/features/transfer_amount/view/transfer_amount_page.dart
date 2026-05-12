import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart' show LocalizationExtension;
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/top_up/data/state/top_up_state.dart';
import 'package:work_hu/features/top_up/providers/top_up_provider.dart';
import 'package:work_hu/features/transfer_amount/data/state/transfer_amount_state.dart';
import 'package:work_hu/features/transfer_amount/providers/transfer_amount_provider.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';

class TransferAmountPage extends BasePage {
  const TransferAmountPage({
    super.key,
  }) : super(title: 'transfer_amount_title');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TransferAmountPageState();
  }
}

class TransferAmountPageState extends BasePageState<TransferAmountPage, TransferAmountState, TransferAmountDataNotifier> {
  final TextEditingController _amountController = TextEditingController(text: "0");
  final TextEditingController userController = TextEditingController(text: "");

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32.sp),

        // Amount Input Card
        BaseContainer(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserComboWidget(
                    controller: userController,
                    onSuggestionSelected: (suggestion) {
                      ref.read(provider.notifier).setSelectedUser(suggestion);
                    },
                    fldControl: "3",
                    labelText: "transfer_amount_to".i18n()),
                SizedBox(
                  height: 8.sp,
                ),
                Text('top_up_enter_amount'.i18n(), style: theme.textTheme.labelLarge),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.sp),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: 'Ft     ',
                      prefixStyle: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [1000, 2000, 5000].map((amt) {
                    bool isSelected = _amountController.text == amt.toString();
                    return _AmountPresetButton(
                      label: '$amt Ft',
                      isSelected: isSelected,
                      onTap: () => _amountController.text = amt.toString(),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.sp),
        SizedBox(
          width: double.infinity,
          height: 56.sp,
          child: FilledButton(
            onPressed: state.selectedUser == null
                ? null
                : () {
                    ref
                        .watch(provider.notifier)
                        .transfer(amount: int.tryParse(_amountController.text) ?? 0)
                        .then((value) async {});
                  },
            child: Text(
              'top_up_confirm_amount'.i18n(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        SizedBox(height: 16.sp),
        Center(
          child: Text(
            'top_up_immediate'.i18n(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    ));
  }

  @override
  AutoDisposeStateNotifierProvider<TransferAmountDataNotifier, TransferAmountState> get provider => transferAmountDataProvider;

  @override
  BaseState get status => state.status;
}

class _AmountPresetButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountPresetButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile(
      {required this.title, required this.subtitle, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.colorScheme.surface),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? theme.colorScheme.primary : theme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedAddButton extends StatelessWidget {
  final String label;

  const _DashedAddButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: theme.dividerColor, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          Icon(Icons.add, color: theme.hintColor),
          SizedBox(width: 16),
          Text(label, style: theme.textTheme.labelLarge?.copyWith(color: theme.hintColor)),
        ],
      ),
    );
  }
}
