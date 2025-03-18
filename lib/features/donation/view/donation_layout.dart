import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/donation/widgets/donation_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class DonationsLayout extends ConsumerStatefulWidget {
  const DonationsLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationsState();
}

class _DonationsState extends ConsumerState<DonationsLayout> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(donationDataProvider.notifier).getDonations(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    var donations = ref.watch(donationDataProvider).donations;
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => ref.read(donationDataProvider.notifier).getDonations(null),
          child: Column(children: [
            Expanded(
                child: BaseListView(
              itemBuilder: (BuildContext context, int index) {
                var current = donations[index];
                var date = current.startDateTime!;
                var dateString = Utils.dateToString(date);
                var endDateString = Utils.dateToString(current.endDateTime!);
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) => showDialog(
                            context: context,
                            builder: (buildContext) {
                              return ConfirmAlertDialog(
                                onConfirm: () => buildContext.pop(true),
                                title: "delete".i18n(),
                                content: Text("donation_delete_warning".i18n(), textAlign: TextAlign.center),
                              );
                            })
                        .then((confirmed) => confirmed != null && confirmed
                            ? ref.read(donationDataProvider.notifier).deleteDonations(current.id!, index)
                            : null),
                    dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      child: BaseListTile(
                        isLast: donations.length - 1 == index,
                        index: index,
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => DonationMaintenance(
                                    mode: MaintenanceMode.create,
                                    donation: current,
                                  )).then((value) => ref.watch(donationDataProvider.notifier).getDonations(null));
                        },
                        leading: Icon(
                          isDonationOpen(current.startDateTime!, current.endDateTime!) ? Icons.lock_open : Icons.lock_outline,
                          color: isDonationOpen(current.startDateTime!, current.endDateTime!) ? Colors.green : Colors.red,
                        ),
                        title: Text(current.description.toString()),
                        subtitle: Text("$dateString - $endDateString"),
                      ),
                    ));
              },
              itemCount: donations.length,
              shadowColor: Colors.transparent,
              cardBackgroundColor: Colors.transparent,
              children: const [],
            ))
          ]),
        ),
        Positioned(
          bottom: 20.sp,
          right: 20.sp,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => DonationMaintenance(
                        mode: MaintenanceMode.create,
                        donation: DonationModel(startDateTime: DateTime.now()),
                      )).then((value) => ref.watch(donationDataProvider.notifier).getDonations(null));
            },
            child: const Icon(Icons.add),
          ),
        ),
        if (ref.watch(donationDataProvider).modelState == ModelState.processing)
          const Dialog(
            backgroundColor: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }

  bool isDonationOpen(DateTime startDateTime, DateTime endDateTime) {
    return DateTime.now().compareTo(endDateTime) <= 0 && DateTime.now().compareTo(startDateTime) >= 0;
  }
}
