import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/utils.dart';

class StatusPage extends BasePage {
  StatusPage({super.key, super.title = "status_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return StatusPageState();
  }
}

class StatusPageState extends BasePageState<StatusPage, StatusState, StatusDataNotifier> {
  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var child in state.statuses)
          Column(
            children: [
              BaseContainer(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(child.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        Utils.percentFormatting(child.status * 100),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("status_goal".i18n([Utils.creditFormatting(child.goal).toString()])),
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Utils.creditFormatting(child.transactions),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        child.onTrack
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.done_outline,
                                    size: 24.sp,
                                  ),
                                  const Text(
                                    "On Track",
                                  )
                                ],
                              )
                            : Text('status_to_onTrack'.i18n([Utils.creditFormatting(child.toOnTrack).toString()]),
                                style: theme.textTheme.bodySmall),
                      ],
                    ),
                    SizedBox(height: 8.sp),
                    LinearProgressIndicator(
                      value: max(0, double.tryParse(child.status.toString()) ?? 0),
                      minHeight: 10.sp,
                      borderRadius: BorderRadius.circular(10.sp),
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.sp),
            ],
          ),

        // Horizontal Stats
        // Row(
        //   children: [
        //     Expanded(
        //       child: BaseContainer(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text('home_remaining_amount'.i18n(), style: theme.textTheme.labelSmall),
        //             SizedBox(height: 8.sp),
        //             Text('2.975.000 Ft', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: 12.sp),
        //     Expanded(
        //       child: BaseContainer(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text('home_expected_completion'.i18n(), style: theme.textTheme.labelSmall),
        //             SizedBox(height: 8.sp),
        //             Text('2025. Okt.',
        //                 style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple.shade300)),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        //
        // SizedBox(height: 32.sp),
        // Text('home_monthly_performance'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        // SizedBox(height: 16.sp),
        //
        // // Performance Grid
        // BaseContainer(
        //   child: GridView.count(
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     crossAxisCount: 3,
        //     mainAxisSpacing: 15.sp,
        //     children: [
        //       _MonthStatus(month: 'Március', status: true),
        //       _MonthStatus(month: 'Április', status: true),
        //       _MonthStatus(month: 'Május', status: null),
        //       _MonthStatus(month: 'Június', status: true),
        //       _MonthStatus(month: 'Július', status: true),
        //       _MonthStatus(month: 'Augusztus', status: false, isCurrent: true),
        //     ],
        //   ),
        // ),
        //
        // SizedBox(height: 32.sp),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('home_recent_transactions'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        //     TextButton(onPressed: () {}, child: Text('home_view_all'.i18n(), style: TextStyle(color: colorScheme.primary))),
        //   ],
        // ),
        //
        // // Transaction List
        // _TransactionTile(
        //     title: 'home_monthly_savings'.i18n(), date: 'Augusztus 12.', amount: '+150.000 Ft', icon: Icons.savings_outlined),
        // SizedBox(height: 12.sp),
        // _TransactionTile(
        //     title: 'home_bonus_deposit'.i18n(), date: 'Augusztus 05.', amount: '+45.000 Ft', icon: Icons.add_card_outlined),
        // SizedBox(height: 12.sp),
        // _TransactionTile(title: 'home_auto_transfer'.i18n(), date: 'Július 28.', amount: '+150.000 Ft', icon: Icons.history),
        // SizedBox(height: 100.sp), // Space for FAB
      ],
    );
  }

  @override
  AutoDisposeStateNotifierProvider<StatusDataNotifier, StatusState> get provider => statusDataProvider;

  @override
  BaseState get status => state.status;
}

class _MonthStatus extends StatelessWidget {
  final String month;
  final bool? status; // true: check, false: more, null: minus
  final bool isCurrent;

  const _MonthStatus({required this.month, this.status, this.isCurrent = false});

  @override
  Widget build(BuildContext context) {
    final color = isCurrent ? Theme.of(context).colorScheme.primary : Colors.grey;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
            color: isCurrent ? Colors.transparent : Colors.grey.withOpacity(0.1),
          ),
          child: Icon(
            status == true ? Icons.check : (status == false ? Icons.more_horiz : Icons.remove),
            color: isCurrent ? color : Colors.grey,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 8.sp),
        Text(
          month,
          style: TextStyle(
            color: isCurrent ? color : Colors.grey,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title, date, amount;
  final IconData icon;

  const _TransactionTile({required this.title, required this.date, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      child: Row(
        children: [
          _IconBox(icon: icon),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
