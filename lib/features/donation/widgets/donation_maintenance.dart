import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';

class DonationMaintenance extends ConsumerStatefulWidget {
  const DonationMaintenance({super.key, required this.mode, required this.donation});

  final MaintenanceMode mode;
  final DonationModel donation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DonationMaintenanceState();
  }
}

class DonationMaintenanceState extends ConsumerState<DonationMaintenance> {
  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(donationDataProvider.notifier).preset(widget.donation, widget.mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(donationDataProvider).mode;
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "${mode}_donation".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          MaterialButton(
            onPressed: () => _formKey.currentState != null && _formKey.currentState!.validate()
                ? ref.read(donationDataProvider.notifier).saveDonation().then((value) => context.pop())
                : null,
            child: const Text("Save"),
          )
        ],
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
                      labelText: "donation_description".i18n(),
                      controller: ref.watch(donationDataProvider.notifier).descriptionController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'cannot_be_empty'.i18n();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: BaseTextFormField(
                      labelText: "donation_description_no".i18n(),
                      controller: ref.watch(donationDataProvider.notifier).descriptionNoController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'cannot_be_empty'.i18n();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        controller: ref.watch(donationDataProvider.notifier).startDateTimeController,
                        textInputAction: TextInputAction.next,
                        labelText: "donation_start_date".i18n(),
                        suffix: IconButton(
                          onPressed: () => _selectDate(context, ref.watch(donationDataProvider.notifier).startDateTimeController),
                          icon: const Icon(Icons.calendar_month),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'cannot_be_empty'.i18n();
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        controller: ref.watch(donationDataProvider.notifier).endDateTimeController,
                        textInputAction: TextInputAction.send,
                        labelText: "donation_end_date".i18n(),
                        suffix: IconButton(
                          onPressed: () => _selectDate(context, ref.watch(donationDataProvider.notifier).endDateTimeController),
                          icon: const Icon(Icons.calendar_month),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'cannot_be_empty'.i18n();
                          }
                          if ((DateTime.tryParse(ref.watch(donationDataProvider.notifier).startDateTimeController.text) ??
                                      DateTime.now())
                                  .compareTo(DateTime.tryParse(text) ?? DateTime.now()) >=
                              0) {
                            return 'donation_date_error'.i18n();
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    ));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null && context.mounted) {
      final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      if (time != null) {
        var dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        controller.text = dateTime.toString();
      }
    }
  }
}
