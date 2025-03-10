import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/payment_state.dart';
import 'package:work_hu/app/widgets/list_separator.dart';

class BufePaymentPage extends StatefulWidget {
  final String base64Params;

  const BufePaymentPage({required this.base64Params, super.key});

  @override
  SumUpPaymentPageState createState() => SumUpPaymentPageState();
}

class SumUpPaymentPageState extends State<BufePaymentPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> paymentData = jsonDecode(utf8.decode(base64.decode(widget.base64Params)));
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Center(child: Text("payment".i18n()))),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(12.sp),
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Column(
                children: [
                  buildPaymentData('payment_description', paymentData['description']),
                  buildPaymentData('payment_amount', "${paymentData['amount']} Ft"),
                ],
              ),
            ),
          ),
          Expanded(
            child: HtmlElementView(
              key: UniqueKey(),
              viewType: 'sumup-iframe-${paymentData['checkoutId']}',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      try {
                        showPaymentState(context, PaymentState.canceled).then((value) => context.mounted && context.canPop()
                            ? context.pop(PaymentState.canceled)
                            : context.pushReplacement("/"));
                      } catch (e) {
                        log(e.toString());
                        context.pushReplacement("/");
                      }
                    },
                    child: Text("cancel_payment".i18n()),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildPaymentData(String key, dynamic value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(child: Text(key.i18n(), style: Theme.of(context).textTheme.labelLarge)),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.labelLarge,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    String sumupUrl = "https://pay-dukapp.netlify.app/?data=${widget.base64Params}";
    Map<String, dynamic> paymentData = jsonDecode(utf8.decode(base64.decode(widget.base64Params)));

    // String sumupUrl = "http://localhost:8800/?data=${widget.base64Params}";
    final iframe = html.IFrameElement()
      ..src = sumupUrl
      ..allow = 'payment'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..width = '100%'
      ..height = '100%';

    ui.platformViewRegistry.registerViewFactory('sumup-iframe-${paymentData['checkoutId']}', (int viewId) => iframe);

    // Listen for messages from the iframe
    html.window.addEventListener('message', (event) {
      final message = (event as html.MessageEvent).data;
      if (message is String) {
        if (message == 'SUCCESS') {
          showPaymentState(context, PaymentState.success).then((value) async {
            context.mounted ? context.pop(PaymentState.success) : null;
          });
        } else if (message == 'FAILED' || message == 'ERROR') {
          showPaymentState(context, PaymentState.error)
              .then((value) => value != null && value == PaymentState.canceled ? null : context.pop(PaymentState.error));
        }
      }
    });
  }

  Future<PaymentState?> showPaymentState(BuildContext context, PaymentState state) async {
    return await showModalBottomSheet<PaymentState>(
        context: context,
        isDismissible: false,
        backgroundColor: state == PaymentState.error
            ? Colors.red.shade300
            : state == PaymentState.success
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
                      state == PaymentState.error
                          ? Icons.cancel
                          : state == PaymentState.success
                              ? Icons.done_rounded
                              : Icons.cancel,
                      size: 60.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state == PaymentState.success
                              ? 'payment_successful'.i18n()
                              : state == PaymentState.error
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
                            state == PaymentState.success
                                ? 'payment_successful_text'.i18n(["Google Pay", "500"])
                                : state == PaymentState.error
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
                  if (state == PaymentState.error)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                        child: TextButton(onPressed: () => modalContext.pop(PaymentState.canceled), child: Text("retry".i18n())),
                      ),
                    )
                ],
              )
            ],
          );
        });
  }
}
