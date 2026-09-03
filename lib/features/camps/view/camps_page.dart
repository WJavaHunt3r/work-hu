import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/camps/data/state/camp_state.dart';
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

class CampPageState extends BaseListPageState<CampPage, CampState, CampDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as CampModel;
    var index = items.indexOf(item);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () async {
        await ref.read(campsDataProvider.notifier).presetCamp(item, MaintenanceMode.edit);
        showDialog(barrierDismissible: false, context: context, builder: (context) => CampsMaintenance())
            .then((value) => value != null && value == true ? ref.read(campsDataProvider.notifier).list() : null);
      },
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
  bool canDelete(item) {
    item as CampModel;
    return item.season!.seasonYear == DateTime.now().year;
  }

  @override
  onDelete(e) {
    ref.read(campsDataProvider.notifier).deleteCamp(e.id!);
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.camps;

  @override
  BaseListState get listStatus => state.listState;

  @override
  AutoDisposeStateNotifierProvider<CampDataNotifier, CampState> get provider => campsDataProvider;

  @override
  buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        await ref.read(campsDataProvider.notifier).presetCamp(const CampModel(), MaintenanceMode.create);
        showDialog(barrierDismissible: false, context: context, builder: (context) => CampsMaintenance())
            .then((value) => value != null && value == true ? ref.watch(campsDataProvider.notifier).list() : null);
      },
      child: const Icon(Icons.add),
    );
  }
}
