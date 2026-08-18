import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/features/round_filter_chip/providers/round_filter_chip_provider.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/utils.dart';

class RoundFilterChipPage extends ConsumerStatefulWidget {
  const RoundFilterChipPage({super.key, required this.onSelected});

  final Function(RoundModel? round) onSelected;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoundFilterChipPageState();
  }
}

class RoundFilterChipPageState extends ConsumerState<RoundFilterChipPage> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(roundFilterChipDataProvider);
    return DialogFilterChip<RoundModel>(
        label: "round_months",
        showDelete: false,
        labelValue: (round) =>
            round == null ? "" : "${round.startDateTime.year} - ${Utils.getMonthFromDate(round.startDateTime, context)}",
        onDeleted: () => widget.onSelected(null),
        initialValue: state.currentRound,
        onItemSelected: (e) => widget.onSelected(e),
        children: () async => ref.read(roundFilterChipDataProvider.notifier).list(),
        title: (round) => Text("${round.startDateTime.year} - ${Utils.getMonthFromDate(round.startDateTime, context)}"));
  }
}
