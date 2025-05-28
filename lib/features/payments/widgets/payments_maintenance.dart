import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';

class PaymentMaintenance extends ConsumerStatefulWidget {
  const PaymentMaintenance({super.key, required this.paymentId});

  final num paymentId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PaymentMaintenanceState();
  }
}

class PaymentMaintenanceState extends ConsumerState<PaymentMaintenance> {
  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentDataProvider.notifier).setPaymentId(widget.paymentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var payment = ref.watch(paymentDataProvider).selectedPayment;
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(paymentDataProvider.notifier).setPaymentId(null);
            context.pop();
          },
        ),
        title: Text(
          "payments_view".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: payment == null
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child:ListView.builder(
                itemCount: 5, // Adjust the count based on your needs
                itemBuilder: (context, index) {
                  return TextFormField();
                },
              ),
            )
          : Stack(
              children: [
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: BaseTextFormField(
                                      labelText: "payments_description".i18n(),
                                      enabled: false,
                                      initialValue: payment.description)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: BaseTextFormField(
                                      enabled: false,
                                      labelText: "payments_amount".i18n(),
                                      initialValue: "${payment.amount.toString()} Ft")),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: BaseTextFormField(
                                enabled: false,
                                labelText: "payments_date".i18n(),
                                initialValue: payment.dateTime.toString(),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: BaseTextFormField(
                                enabled: false,
                                labelText: "payments_status".i18n(),
                                initialValue: payment.status.toString(),
                              )),
                              if (payment.status == PaymentStatus.PENDING)
                                IconButton(
                                    onPressed: () => ref.watch(paymentDataProvider.notifier).refreshPayment(),
                                    icon: const Icon(Icons.refresh))
                            ],
                          ),
                          if (payment.paymentGoal == PaymentGoal.DONATION)
                            Row(
                              children: [
                                Expanded(
                                  child: BaseTextFormField(
                                    enabled: false,
                                    initialValue: payment.donation?.description,
                                    textInputAction: TextInputAction.next,
                                    labelText: "payments_donation".i18n(),
                                  ),
                                ),
                              ],
                            ),
                          if (payment.user != null)
                            Row(
                              children: [
                                Expanded(
                                  child: BaseTextFormField(
                                      enabled: false,
                                      initialValue: payment.user!.getFullName(),
                                      labelText: "payments_user".i18n()),
                                ),
                              ],
                            )
                        ],
                      ),
                    )),
                ref.watch(paymentDataProvider).modelState == ModelState.processing
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox()
              ],
            ),
    ));
  }
}
