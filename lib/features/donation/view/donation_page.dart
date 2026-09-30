import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/donation/widgets/donation_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class DonationsPage extends BaseListPage {
  const DonationsPage({super.key, super.title = "donations"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DonationsPageState();
  }
}

class DonationsPageState extends PagedListPageState<DonationsPage, DonationModel, void, DonationDataNotifier> {
  @override
  get provider => donationDataProvider;

  @override
  Widget build(BuildContext context) {
    // The base page only reports errors of the list provider.
    ref.listen(donationMaintenanceProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(DonationModel item, int index) {
    var isOpen = _isDonationOpen(item.startDateTime!, item.endDateTime!);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () => _openMaintenance(item),
      leading: Icon(isOpen ? Icons.lock_open : Icons.lock_outline, color: isOpen ? Colors.green : Colors.red),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(item.description.toString()), Text(item.sum.toString())],
      ),
      subtitle: Text("${Utils.dateToString(item.startDateTime!)} - ${Utils.dateToString(item.endDateTime!)}"),
    );
  }

  void _openMaintenance(DonationModel donation) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DonationMaintenance(mode: MaintenanceMode.create, donation: donation),
    ).then((value) => notifier.reload());
  }

  bool _isDonationOpen(DateTime startDateTime, DateTime endDateTime) {
    return DateTime.now().compareTo(endDateTime) <= 0 && DateTime.now().compareTo(startDateTime) >= 0;
  }

  @override
  bool canDelete(DonationModel item) => true;

  @override
  void onDelete(DonationModel item) => notifier.deleteDonation(item.id!);

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _openMaintenance(DonationModel(startDateTime: DateTime.now())),
      child: const Icon(Icons.add),
    );
  }
}
