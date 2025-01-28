import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/fra_kare_week/providers/fra_kare_week_provider.dart';
import 'package:work_hu/features/utils.dart';

class FraKareWeekLayout extends ConsumerWidget {
  const FraKareWeekLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fraKareWeeks = ref.watch(fraKareWeekDataProvider).weeks;
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async => ref.read(fraKareWeekDataProvider.notifier).getFraKareWeeks(DateTime.now().year),
        child: Column(children: [
          // Padding(
          //   padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
          //   child: DropdownButtonFormField<RoundModel>(
          //       decoration: InputDecoration(labelText: "fraKareWeek_round".i18n()),
          //       value: ref.watch(fraKareWeekDataProvider).rounds.isEmpty
          //           ? null
          //           : ref
          //               .watch(fraKareWeekDataProvider)
          //               .rounds
          //               .firstWhere((r) => r.id == ref.watch(fraKareWeekDataProvider).selectedRoundId),
          //       items: ref
          //           .watch(fraKareWeekDataProvider)
          //           .rounds
          //           .map((e) => DropdownMenuItem<RoundModel>(
          //                 value: e,
          //                 child: Text("${e.season.seasonYear.toString()}/${e.roundNumber}"),
          //               ))
          //           .toList(),
          //       onChanged: (value) => ref.watch(fraKareWeekDataProvider.notifier).setSelectedRound(value?.id ?? 0)),
          // ),
          Expanded(
              child: BaseListView(
            itemBuilder: (BuildContext context, int index) {
              var current = fraKareWeeks[index];
              return BaseListTile(
                  isLast: fraKareWeeks.length - 1 == index,
                  index: index,
                  enabled: !current.locked,
                  onTap: () {
                    // ref.watch(userFraKareWeekDataProvider.notifier).getFraKareWeeks(current.weekNumber);
                    context.push("/admin/fraKareWeeks/${current.weekNumber}");
                  },
                  title: Text("fra_kare_week_weekNumber".i18n([current.weekNumber.toString()])),
                  subtitle: Text(
                      "${Utils.dateToString(current.weekStartDate)} - ${Utils.dateToString(current.weekEndDate)}"));
            },
            itemCount: ref.watch(fraKareWeekDataProvider).weeks.length,
            shadowColor: Colors.transparent,
            cardBackgroundColor: Colors.transparent,
            children: const [],
          ))
        ]),
      ),
      ref.watch(fraKareWeekDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(fraKareWeekDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(fraKareWeekDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }
}
