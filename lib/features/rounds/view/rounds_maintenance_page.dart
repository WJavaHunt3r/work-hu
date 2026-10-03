import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/rounds/data/state/round_detail_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

class RoundsMaintenancePage extends BasePage {
  const RoundsMaintenancePage({super.key, super.title = "rounds_maintenance", required this.id});

  final num id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundsMaintenancePageState();
  }
}

class RoundsMaintenancePageState extends BasePageState<RoundsMaintenancePage, RoundDetailState, RoundDetailNotifier> {
  @override
  void postInit(WidgetRef ref) {
    super.postInit(ref);
    ref.read(roundDetailProvider.notifier).getRound(widget.id);
  }

  @override
  Widget buildLayout() {
    var round = state.round;
    return round == null
        ? const Column(children: [Text("rounds_maintenance_noneSelected")])
        : Column(
            children: [
              Row(
                children: [
                  BaseTextFormField(
                    labelText: "rounds_maintenance_roundNumber".i18n(),
                    controller: TextEditingController(text: state.round?.roundNumber.toString()),
                  ),
                  BaseTextFormField(
                    labelText: "rounds_maintenance_season".i18n(),
                    controller: TextEditingController(text: state.round?.season.seasonYear.toString()),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Row(
                children: [
                  BaseTextFormField(
                    labelText: "rounds_maintenance_startDate".i18n(),
                    controller: TextEditingController(text: state.round?.startDateTime.toString()),
                  ),
                  BaseTextFormField(
                    labelText: "rounds_maintenance_endDate".i18n(),
                    controller: TextEditingController(text: state.round?.endDateTime.toString()),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Row(
                children: [
                  BaseTextFormField(
                    labelText: "rounds_maintenance_localGoal".i18n(),
                    controller: TextEditingController(text: state.round?.localMyShareGoal.toString()),
                  ),
                  BaseTextFormField(
                    labelText: "rounds_maintenance_goal".i18n(),
                    controller: TextEditingController(text: state.round?.myShareGoal.toString()),
                  ),
                ],
              ),
            ],
          );
  }

  @override
  StateNotifierProvider<RoundDetailNotifier, RoundDetailState> get provider => roundDetailProvider;

  @override
  BaseState get status => state.status;
}
