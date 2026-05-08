import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/donate/data/state/donate_state.dart';
import 'package:work_hu/features/donate/providers/donate_provider.dart';

class DonatePage extends BasePage {
  const DonatePage({super.key, required this.id, super.title = "donate"});

  final num id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DonatePageState();
  }
}

class DonatePageState extends BasePageState<DonatePage, DonateState, DonateDataNotifier> {
  final TextEditingController _amountController = TextEditingController(text: "0");

  @override
  void postInit(WidgetRef ref) {
    ref.read(provider.notifier).getDonation(widget.id);
  }

  void _updateAmount(int amount) {
    setState(() => _amountController.text = amount.toString());
  }

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    return state.donation == null
        ? Column(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                  ref.watch(localeProvider).value == const Locale("hu", "HU")
                      ? state.donation!.description.toString()
                      : state.donation!.descriptionNO.toString(),
                  style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 40,
              ),
              _buildDonateCard(theme),
              const SizedBox(
                height: 40,
              ),
              _buildConfirmButton(theme)
            ],
          );
  }

  @override
  get provider => donateDataProvider;

  @override
  BaseState get status => state.status;

  Widget _buildConfirmButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: () {
          if ((num.tryParse(_amountController.text) ?? 0) != 0) {
            ref.watch(provider.notifier).createCheckout(int.tryParse(_amountController.text) ?? 0).then((value) async {
              if (status.modelState.isSuccess && state.hosted_url != null && state.hosted_url!.isNotEmpty) {
                Uri uri = Uri.parse(state.hosted_url.toString());
                if (!await launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: "_self")) {
                  throw Exception('top_up_failed_to_launch'.i18n([uri.toString()]));
                }
              }
            });
          }
        },
        child: Text('top_up_confirm_amount'.i18n(), style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  _buildDonateCard(ThemeData theme) {
    return BaseContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('top_up_enter_amount'.i18n(), style: theme.textTheme.labelLarge),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [2000, 5000, 10000].map((amt) {
              bool isSelected = _amountController.text == amt.toString();
              return _AmountPresetButton(
                label: '$amt Ft',
                isSelected: isSelected,
                onTap: () => _updateAmount(amt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
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
