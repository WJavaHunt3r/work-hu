import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/payment_success/data/state/payment_success_state.dart';
import 'package:work_hu/features/payment_success/providers/payment_success_provider.dart';
import 'package:work_hu/features/utils.dart';

class PaymentSuccessPage extends BasePage {
  const PaymentSuccessPage(
      {super.key, this.checkoutReference, super.hasAppBar = false, super.title = "payment_success", super.canRefresh = false});

  final String? checkoutReference;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PaymentSuccessStatePage();
  }
}

class PaymentSuccessStatePage extends BasePageState<PaymentSuccessPage, PaymentSuccessState, PaymentSuccessDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    ref.watch(paymentSuccessDataProvider.notifier).refreshSumupPayment(checkoutReference: widget.checkoutReference ?? "");
  }

  @override
  Widget buildLayout() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: state.status.modelState.isSuccess
            ? state.payment!.status == PaymentStatus.PAID
                ? buildSuccessPage(theme, colorScheme, state.payment!)
                : buildErrorPage(theme, colorScheme, state.payment!)
            : state.status.modelState.isError
                ? Center(child: Text("payment_success_error".i18n()))
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildSuccessPage(ThemeData theme, ColorScheme colorScheme, SumupCheckoutModel payment) {
    return Column(
      children: [
        SizedBox(height: 40.sp),
        // Success Icon with Glow
        Center(
          child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withAlpha(10),
            ),
            child: Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withAlpha(20),
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 64.sp,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.sp),
        Text(
          'payment_success_successful'.i18n(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.sp),
        Text(
          'payment_success_transaction_processed'.i18n(),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
        SizedBox(height: 32.sp),

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
              SizedBox(height: 8.sp),
              Text(
                Utils.creditFormatting(payment.amount), // Usually passed as a param
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 18.sp,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: 8.sp),
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

        SizedBox(height: 32.sp),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'payment_success_transaction_details'.i18n(),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16.sp),

        // Details Card
        BaseContainer(
          child: Column(
            children: [
              _DetailRow(label: 'payment_success_transaction_id'.i18n(), value: payment.checkoutReference),
              Divider(height: 24.sp),
              _DetailRow(
                  label: 'payment_success_date_time'.i18n(),
                  value: DateFormat('MMM dd, yyyy • HH:mm').format(payment.transactionDate)),
              Divider(height: 24.sp),
              _DetailRow(
                label: 'payment_success_payment_method'.i18n(),
                value: payment.entryMode!,
                icon: payment.entryMode == 'APPLE_PAY'
                    ? Icons.apple
                    : payment.entryMode == 'GOOGLE_PAY'
                        ? Icons.g_mobiledata
                        : Icons.credit_card,
              ),
            ],
          ),
        ),

        SizedBox(height: 40.sp),
        // Primary Action
        SizedBox(
          width: double.infinity,
          height: 56.sp,
          child: FilledButton(
            onPressed: () => context.go("/balance"),
            child: Text('payment_success_back_to_home'.i18n(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 12.sp),
      ],
    );
  }

  @override
  StateNotifierProvider<PaymentSuccessDataNotifier, PaymentSuccessState> get provider => paymentSuccessDataProvider;

  @override
  BaseState get status => state.status;

  buildErrorPage(ThemeData theme, ColorScheme colorScheme, SumupCheckoutModel payment) {
    var errorColor = colorScheme.error;
    return Column(children: [
      SizedBox(height: 40.sp),
      Center(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: errorColor.withAlpha(25),
          ),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: errorColor.withAlpha(40),
            ),
            child: Icon(
              Icons.cancel_outlined,
              size: 64.sp,
              color: errorColor,
            ),
          ),
        ),
      ),
      SizedBox(height: 24.sp),

      Text(
        'payment_success_failed'.i18n(),
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      SizedBox(height: 12.sp),

      Text(
        'payment_success_failed_subtitle'.i18n(),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
          height: 1.5,
        ),
      ),
      SizedBox(height: 40.sp),

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
            SizedBox(height: 12.sp),
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

      SizedBox(height: 32.sp),

      // Actions
      SizedBox(
        width: double.infinity,
        height: 56.sp,
        child: FilledButton(
          onPressed: () async {
            Uri uri = Uri.parse(state.payment!.hostedUrl.toString());
            if (!await launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: "_self")) {
              throw Exception('top_up_failed_to_launch'.i18n([uri.toString()]));
            }
          },
          child: Text(
            'payment_success_try_again'.i18n(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SizedBox(height: 12.sp),

      SizedBox(
        width: double.infinity,
        height: 56.sp,
        child: OutlinedButton(
          onPressed: () => context.go("/balance"),
          child: Text(
            'payment_success_back_to_home'.i18n(),
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      SizedBox(height: 48.sp)
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
              Icon(icon, size: 20.sp, color: theme.colorScheme.onSurface),
              SizedBox(width: 8.sp),
            ],
            Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
