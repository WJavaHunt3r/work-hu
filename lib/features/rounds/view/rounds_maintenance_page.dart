import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show AutoDisposeStateNotifierProvider;
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

class RoundsMaintenancePage extends BasePage {
  const RoundsMaintenancePage({super.key, super.title = "rounds_maintenance", required this.id});

  final num id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundsMaintenancePageState();
  }
}

class RoundsMaintenancePageState extends BasePageState<RoundsMaintenancePage, RoundsState, RoundsDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    super.postInit(ref);
    ref.read(roundDataProvider.notifier).getRound(widget.id);
  }

  @override
  Widget buildLayout() {
    var round = state.selectedRound;
    return round == null
        ? const Column(
            children: [Text("rounds_maintenance_noneSelected")],
          )
        : Column(
            children: [
              Row(
                children: [
                  BaseTextFormField(
                      labelText: "rounds_maintenance_roundNumber".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.roundNumber.toString())),
                  BaseTextFormField(
                      labelText: "rounds_maintenance_season".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.season.seasonYear.toString())),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  BaseTextFormField(
                      labelText: "rounds_maintenance_startDate".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.startDateTime.toString())),
                  BaseTextFormField(
                      labelText: "rounds_maintenance_endDate".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.endDateTime.toString())),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  BaseTextFormField(
                      labelText: "rounds_maintenance_localGoal".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.localMyShareGoal.toString())),
                  BaseTextFormField(
                      labelText: "rounds_maintenance_goal".i18n(),
                      controller: TextEditingController(text: state.selectedRound?.myShareGoal.toString())),
                ],
              )
            ],
          );
  }

  @override
  AutoDisposeStateNotifierProvider<RoundsDataNotifier, RoundsState> get provider => roundDataProvider;

  @override
  BaseState get status => state.maintenanceStatus;
}
