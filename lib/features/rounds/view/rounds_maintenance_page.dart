import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/state_notifier_provider.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

class RoundsMaintenancePage extends BasePage {
  const RoundsMaintenancePage({super.key, required super.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundsMaintenancePageState();
  }
}

class RoundsMaintenancePageState extends BasePageState<RoundsMaintenancePage, RoundsState, RoundsDataNotifier>{
  @override
  Widget buildLayout() {
    // TODO: implement buildLayout
    throw UnimplementedError();
  }

  @override
  AutoDisposeStateNotifierProvider<RoundsDataNotifier, RoundsState> get provider => roundDataProvider;

  @override
  BaseState get status => state.maintenanceStatus;

}
