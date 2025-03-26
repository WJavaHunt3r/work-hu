import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/number_pin.dart';

class NumberPinLayout extends StatelessWidget {
  const NumberPinLayout(
      {super.key,
      required this.amount,
      this.checkoutId,
      this.buttonText,
      required this.amountController,
      required this.addNumber,
      required this.createCheckout,
      required this.afterPaymentOccurred,
      required this.path,
      required this.onRemoveNumber});

  final num amount;
  final String? checkoutId;
  final String? buttonText;
  final String path;
  final TextEditingController amountController;
  final Function(String) addNumber;
  final Function createCheckout;
  final Function(dynamic) afterPaymentOccurred;
  final Function onRemoveNumber;

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
                                context.push("/$path/sumup_payment/$checkoutId").then((value) {
                                  afterPaymentOccurred(value);
                                });
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
}
