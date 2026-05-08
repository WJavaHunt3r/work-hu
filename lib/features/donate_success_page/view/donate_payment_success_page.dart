import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/donate/model/checkout_model.dart';
import 'package:work_hu/features/donate_success_page/data/state/donate_payment_success_state.dart';
import 'package:work_hu/features/donate_success_page/providers/donate_payment_success_provider.dart';
import 'package:work_hu/features/utils.dart';

class DonatePaymentSuccessPage extends BasePage {
  const DonatePaymentSuccessPage({
    super.key,
    this.checkoutReference,
    super.hasAppBar = false,
    super.title = "payment_success",
  });

  final String? checkoutReference;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DonatePaymentSuccessStatePage();
  }
}

class DonatePaymentSuccessStatePage
    extends BasePageState<DonatePaymentSuccessPage, DonatePaymentSuccessState, DonatePaymentSuccessDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    ref.watch(provider.notifier).refreshPayment(checkoutReference: widget.checkoutReference ?? "");
  }

  @override
  Widget buildLayout() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    return state.payment == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.status.modelState.isSuccess
                  ? state.payment!.status == PaymentStatus.PAID
                      ? buildSuccessPage(theme, colorScheme, state.payment!)
                      : buildErrorPage(theme, colorScheme, state.payment!)
                  : state.status.modelState.isError
                      ? Center(child: Text("payment_success_error".i18n()))
                      : Center(child: CircularProgressIndicator()),
            ),
          );
  }

  Widget buildSuccessPage(ThemeData theme, ColorScheme colorScheme, CheckoutModel payment) {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Success Icon with Glow
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withAlpha(10),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withAlpha(20),
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'payment_success_successful'.i18n(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'payment_success_transaction_processed'.i18n(),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 32),

        // Summary Card
        BaseContainer(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'payment_success_total_paid'.i18n(),
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.2,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Utils.creditFormatting(payment.amount), // Usually passed as a param
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'payment_success_transaction_approved'.i18n(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'payment_success_transaction_details'.i18n(),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        // Details Card
        BaseContainer(
          child: Column(
            children: [
              _DetailRow(label: 'payment_success_transaction_id'.i18n(), value: payment.description),
              const Divider(height: 24),
              _DetailRow(label: 'payment_success_date_time'.i18n(), value: payment.date),
              // const Divider(height: 24),
              // _DetailRow(
              //   label: 'payment_success_payment_method'.i18n(),
              //   value: payment.!,
              //   icon: payment.entryMode == 'APPLE_PAY'
              //       ? Icons.apple
              //       : payment.entryMode == 'GOOGLE_PAY'
              //           ? Icons.g_mobiledata
              //           : Icons.credit_card,
              // ),
            ],
          ),
        ),

        const SizedBox(height: 40),
        // Primary Action
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: () => context.go("/balance"),
            child: Text('payment_success_back_to_home'.i18n(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  AutoDisposeStateNotifierProvider<DonatePaymentSuccessDataNotifier, DonatePaymentSuccessState> get provider =>
      donatePaymentSuccessDataProvider;

  @override
  BaseState get status => state.status;

  buildErrorPage(ThemeData theme, ColorScheme colorScheme, CheckoutModel payment) {
    var errorColor = colorScheme.error;
    return Column(children: [
      const SizedBox(height: 40),
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: errorColor.withOpacity(0.1),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: errorColor.withOpacity(0.15),
            ),
            child: Icon(
              Icons.cancel_outlined,
              size: 64,
              color: errorColor,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),

      Text(
        'payment_success_failed'.i18n(),
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 12),

      Text(
        'payment_success_failed_subtitle'.i18n(),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 40),

      // Amount Card
      BaseContainer(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'payment_success_amount_to_pay'.i18n(),
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 1.2,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              Utils.creditFormatting(payment.amount),
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: errorColor, // Distinct red for the failed amount
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 32),

      // Actions
      SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: () async {
            Uri uri = Uri.parse(state.payment!.hosted_checkout_url.toString());
            if (!await launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: "_self")) {
              throw Exception('top_up_failed_to_launch'.i18n([uri.toString()]));
            }
          },
          child: Text(
            'payment_success_try_again'.i18n(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(height: 12),

      SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: () => context.go("/balance"),
          child: Text(
            'payment_success_back_to_home'.i18n(),
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 48)
    ]);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _DetailRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: theme.colorScheme.onSurface),
              const SizedBox(width: 8),
            ],
            Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
