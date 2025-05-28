import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/list_separator.dart';
import 'package:work_hu/app/widgets/number_pin.dart';
import 'package:url_launcher/url_launcher.dart';

class NumberPinLayout extends StatelessWidget {
  const NumberPinLayout(
      {super.key,
      required this.amount,
      this.checkoutId,
      this.buttonText,
      required this.amountController,
      required this.addNumber,
      required this.createCheckout,
      required this.path,
      required this.onRemoveNumber,
      this.hostedUrl});

  final num amount;
  final String? checkoutId;
  final String? buttonText;
  final String path;
  final TextEditingController amountController;
  final Function(String) addNumber;
  final Function createCheckout;
  final Function onRemoveNumber;
  final String? hostedUrl;

  @override
  Widget build(BuildContext context) {
    var enabled = amount > 0;
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      // readOnly: ref.watch(donateDataProvider).id != null,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 40.sp, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleMedium?.color),
                      decoration: InputDecoration(
                          suffixText: "Ft",
                          suffixStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                          hintText: "0",
                          filled: false,
                          border: const OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("1"), onTap: () => addNumber("1")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("2"), onTap: () => addNumber("2")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("3"), onTap: () => addNumber("3"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("4"), onTap: () => addNumber("4")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("5"), onTap: () => addNumber("5")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("6"), onTap: () => addNumber("6"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(enabled: true, showBorder: true, child: pinText("7"), onTap: () => addNumber("7")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("8"), onTap: () => addNumber("8")),
                        NumberPin(enabled: true, showBorder: true, child: pinText("9"), onTap: () => addNumber("9"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NumberPin(
                            enabled: enabled,
                            showBorder: false,
                            child: pinText(
                              "00",
                              color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                            ),
                            onTap: () => addNumber("00")),
                        NumberPin(
                            enabled: enabled,
                            showBorder: true,
                            child: pinText("0", color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey),
                            onTap: () => addNumber("0")),
                        NumberPin(
                            enabled: enabled,
                            showBorder: false,
                            child: Icon(
                              Icons.backspace,
                              color: enabled ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                            ),
                            onTap: () => onRemoveNumber())
                      ],
                    )
                  ],
                )),
            checkoutId == null
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                          child: TextButton(
                            onPressed: amount > 0 ? () => createCheckout() : null,
                            child: Text(buttonText != null ? buttonText!.i18n() : "donate_button".i18n()),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                          child: TextButton(
                              onPressed: () {
                                Uri uri = Uri.parse(hostedUrl.toString());
                                _launchUrl(uri);
                                // context.push("/$path/sumup_payment/$checkoutId").then((value) {
                                //   if (value != null && value is PaymentStatus) {
                                //     showPaymentState(context, value);
                                //     value == PaymentStatus.PAID ? paymentSuccessful() : paymentFailure(value);
                                //   } else {
                                //     paymentFailure(PaymentStatus.FAILED);
                                //   }
                                // });
                              },
                              child: Text(
                                "donate_proceed".i18n([amount.toString()]),
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ],
    );
  }

  Widget pinText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 24.sp, color: color),
      textAlign: TextAlign.center,
    );
  }

  Future<PaymentStatus?> showPaymentState(BuildContext context, PaymentStatus state, {num? amount, String? cardData}) async {
    return await showModalBottomSheet<PaymentStatus>(
        context: context,
        isDismissible: false,
        backgroundColor: state == PaymentStatus.FAILED
            ? Colors.red.shade300
            : state == PaymentStatus.PAID
                ? Colors.green
                : Colors.amber,
        enableDrag: false,
        elevation: 4.sp,
        barrierLabel: 'text'.i18n(),
        builder: (modalContext) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state == PaymentStatus.FAILED
                          ? Icons.cancel
                          : state == PaymentStatus.PAID
                              ? Icons.done_rounded
                              : Icons.cancel,
                      size: 60.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state == PaymentStatus.PAID
                              ? 'payment_successful'.i18n()
                              : state == PaymentStatus.FAILED
                                  ? 'payment_error'.i18n()
                                  : 'payment_canceled'.i18n(),
                          textAlign: TextAlign.center,
                          style: Theme.of(modalContext).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            state == PaymentStatus.PAID
                                ? 'payment_successful_text'.i18n([cardData.toString(), amount.toString()])
                                : state == PaymentStatus.FAILED
                                    ? 'payment_error_text'.i18n()
                                    : 'payment_canceled_text'.i18n(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListSeparator(padding: 8.sp, height: 1.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                      child: TextButton(onPressed: () => modalContext.pop(state), child: Text("ok".i18n())),
                    ),
                  ),
                  if (state == PaymentStatus.FAILED)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                        child: TextButton(onPressed: () => modalContext.pop(PaymentStatus.PENDING), child: Text("retry".i18n())),
                      ),
                    )
                ],
              )
            ],
          );
        });
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: "_self")) {
      throw Exception('Could not launch $uri');
    }
  }
}
