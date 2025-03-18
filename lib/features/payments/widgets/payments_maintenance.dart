import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

class PaymentMaintenance extends ConsumerStatefulWidget {
  const PaymentMaintenance({super.key, required this.payment});

  final PaymentsModel payment;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PaymentMaintenanceState();
  }
}

class PaymentMaintenanceState extends ConsumerState<PaymentMaintenance> {
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "payments_view".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: BaseTextFormField(
                            labelText: "payments_description".i18n(), initialValue: widget.payment.description)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: BaseTextFormField(
                      labelText: "payments_".i18n(),
                      initialValue: widget.payment.description,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        initialValue: widget.payment.description,
                        textInputAction: TextInputAction.next,
                        labelText: "payments_start_date".i18n(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(initialValue: widget.payment.description, labelText: "payments_end_date".i18n()),
                    ),
                  ],
                )
              ],
            ),
          )),
    ));
  }
}
