import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/icon_box.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/user_transactions/widgets/points_list_item.dart';
import 'package:work_hu/features/utils.dart';

class StatusPage extends BasePage {
  const StatusPage({super.key, super.title = "status_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return StatusPageState();
  }
}

class StatusPageState extends BasePageState<StatusPage, StatusState, StatusDataNotifier> {
  @override
  void onRefresh() {
    ref.read(statusDataProvider.notifier).getUserInfoAndUserRounds();
  }

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'status_local_status'.i18n(),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Text(
                    'status_monthly_goal'.i18n([Utils.percentFormatting(state.userRoundHead.localMyShareGoal)]),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.sp),
            Row(
              children: [
                Expanded(
                  child: _OnTrackStatus(
                    title: "status_local_on_track_title".i18n(),
                    data: "status_local_on_track_data".i18n([state.userRoundHead.onTrackCount.toString()]),
                    subData: "status_local_on_track_subData".i18n([state.userRoundHead.goalCount.toString()]),
                    icon: Icons.stacked_line_chart,
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: _OnTrackStatus(
                    title: "status_local_required_title".i18n(),
                    data: "status_local_required_data".i18n([state.userRoundHead.toOnTrackCount.toString()]),
                    subData: "status_local_required_subData".i18n([state.userRoundHead.churchGoal.toString()]),
                    icon: Icons.stars,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        if (state.statuses.isNotEmpty)
          Text('status_my_status'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.sp),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("status_goal".i18n([Utils.creditFormatting(child.goal).toString()])),
                          Text(
                            "status_monthly_goal".i18n([Utils.percentFormatting(state.userRoundHead.localMyShareGoal)]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.creditFormatting(child.transactions),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        child.localOnTrack
                            ? Row(
                                children: [
                                  Icon(Icons.done_outline, size: 24.sp),
                                  const Text("On Track"),
                                ],
                              )
                            : Text(
                                'status_to_onTrack'.i18n([Utils.creditFormatting(child.toOnTrack).toString()]),
                                style: theme.textTheme.bodySmall,
                              ),
                      ],
                    ),
                    SizedBox(height: 8.sp),
                    _GoalProgressBar(
                      value: max(0, double.tryParse(child.status.toString()) ?? 0),
                      goal: state.userRoundHead.localMyShareGoal / 100,
                    ),
                    if (child.userId != locator<UserProvider>().user!.id)
                      BaseListTile(
                        isLast: false,
                        contentPadding: EdgeInsets.only(top: 12.sp),
                        index: 2,
                        title: Text(
                          'status_recent_transactions'.i18n(),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          context.push('/status/transactions/${child.userId}');
                        },
                        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
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
        SizedBox(height: 16.sp),

        if (state.transactions.isNotEmpty)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'status_recent_transactions'.i18n(),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/status/transactions/${locator<UserProvider>().user!.id}');
                    },
                    child: Text('status_view_all'.i18n(), style: TextStyle(color: colorScheme.primary)),
                  ),
                ],
              ),
              SizedBox(height: 12.sp),
              ...state.transactions.map(
                (e) => TransactionTile(
                  title: e.description,
                  date: Utils.dateFormating(e.transactionDate),
                  amount: Utils.creditFormatting(e.credit),
                  transactionType: e.transactionType,
                ),
              ),
            ],
          ),

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
  StateNotifierProvider<StatusDataNotifier, StatusState> get provider => statusDataProvider;

  @override
  BaseState get status => state.status;
}

class _OnTrackStatus extends StatelessWidget {
  final String title;
  final String data;
  final String subData;
  final IconData icon;

  const _OnTrackStatus({required this.title, required this.data, required this.subData, required this.icon});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconBox(icon: icon),
            ],
          ),
          SizedBox(height: 8.sp),
          Text(data, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(subData, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _GoalProgressBar extends StatelessWidget {
  final double value;
  final double goal;

  const _GoalProgressBar({required this.value, required this.goal});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          LinearProgressIndicator(
            value: value,
            minHeight: 10.sp,
            borderRadius: BorderRadius.circular(10.sp),
            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            color: colorScheme.primary,
          ),
          if (goal > 0 && goal < 1)
            Positioned(
              left: constraints.maxWidth * goal - 1.5.sp,
              top: -3.sp,
              child: Container(
                width: 3.sp,
                height: 16.sp,
                decoration: BoxDecoration(color: colorScheme.onSurface, borderRadius: BorderRadius.circular(2.sp)),
              ),
            ),
        ],
      ),
    );
  }
}
