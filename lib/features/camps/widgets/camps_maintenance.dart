import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/camps/provider/camps_provider.dart';

class CampsMaintenance extends ConsumerWidget {
  CampsMaintenance({super.key});

  final TextEditingController userController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(campsDataProvider).mode.name;
    final CampModel camp = ref.watch(campsDataProvider).selectedCamp;
    var year = camp.season!.seasonYear;
    return Dialog.fullscreen(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(false),
        ),
        title: Text(
          "maintenance_mode_$mode".i18n(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          MaterialButton(
            onPressed: () => ref.read(campsDataProvider.notifier).saveCamp().then((value) => context.pop(true)),
            child: const Text("camp_maintenance_save"),
          )
        ],
      ),
      body: camp.season == null
          ? const SizedBox()
          : Form(
              key: _formKey,
              onPopInvoked: (pop) => ref.read(campsDataProvider.notifier).presetCamp(const CampModel(), MaintenanceMode.create),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextFormField(
                            enabled: false,
                            labelText: "camp_maintenance_season".i18n(),
                            initialValue: camp.season == null ? "0" : camp.season!.seasonYear.toString(),
                            onChanged: (season) => {},
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: BaseTextFormField(
                            labelText: "camp_maintenance_campName".i18n(),
                            initialValue: camp.campName,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref.read(campsDataProvider.notifier).updateCamp(camp.copyWith(campName: text))
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextFormField(
                            labelText: "camp_maintenance_u18_brunstad".i18n(),
                            initialValue: camp.u18BrunstadFee,
                            keyBoardType: TextInputType.number,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref
                                    .read(campsDataProvider.notifier)
                                    .updateCamp(camp.copyWith(u18BrunstadFee: num.tryParse(text) ?? 0))
                                : null,
                          ),
                        ),
                        Expanded(
                          child: BaseTextFormField(
                            labelText: "camp_maintenance_o18_brunstad".i18n(),
                            initialValue: camp.o18BrunstadFee,
                            keyBoardType: TextInputType.number,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref
                                    .read(campsDataProvider.notifier)
                                    .updateCamp(camp.copyWith(o18BrunstadFee: num.tryParse(text) ?? 0))
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BaseTextFormField(
                            labelText: "camp_maintenance_u18_local".i18n(),
                            initialValue: camp.u18LocalFee,
                            keyBoardType: TextInputType.number,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref
                                    .read(campsDataProvider.notifier)
                                    .updateCamp(camp.copyWith(u18LocalFee: num.tryParse(text) ?? 0))
                                : null,
                          ),
                        ),
                        Expanded(
                          child: BaseTextFormField(
                            labelText: "camp_maintenance_o18_local".i18n(),
                            initialValue: camp.o18LocalFee,
                            keyBoardType: TextInputType.number,
                            onChanged: (String text) => text.isNotEmpty
                                ? ref
                                    .read(campsDataProvider.notifier)
                                    .updateCamp(camp.copyWith(o18LocalFee: num.tryParse(text) ?? 0))
                                : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
    ));
  }
}
