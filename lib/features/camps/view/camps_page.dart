import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/camps/provider/camps_provider.dart';
import 'package:work_hu/features/camps/widgets/camps_maintenance.dart';
import 'package:work_hu/features/utils.dart';

class CampPage extends BaseListPage {
  const CampPage({super.key, super.title = "admin_camps"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CampPageState();
  }
}

class CampPageState extends PagedListPageState<CampPage, CampModel, CampFilter, CampDataNotifier> {
  @override
  Widget build(BuildContext context) {
    // Keeps the maintenance state alive between presetting a camp and the dialog watching it.
    ref.listen(campMaintenanceProvider, (previous, next) {});
    return super.build(context);
  }

  @override
  Widget buildListTile(CampModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      onTap: () => _openMaintenance(item, MaintenanceMode.edit),
      title: Text(item.campName!),
      subtitle: Column(
        children: [
          Text("camps_o18_fee".i18n([Utils.creditFormatting(item.o18BrunstadFee ?? 0)])),
          Text("camps_u18_fee".i18n([Utils.creditFormatting(item.u18BrunstadFee ?? 0)])),
        ],
      ),
    );
  }

  @override
  bool canDelete(CampModel item) => item.season!.seasonYear == DateTime.now().year;

  @override
  void onDelete(CampModel item) => notifier.deleteCamp(item.id!);

  @override
  get provider => campsDataProvider;

  @override
  buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _openMaintenance(const CampModel(), MaintenanceMode.create),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _openMaintenance(CampModel camp, MaintenanceMode mode) async {
    await ref.read(campMaintenanceProvider.notifier).presetCamp(camp, mode);
    if (!mounted) return;
    final saved = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => CampsMaintenance(),
    );
    if (saved == true) notifier.reload();
  }
}
