import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';

class StatusPage extends BasePage {
  const StatusPage({super.key, super.title = "profile_title"});

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Header
          const SizedBox(height: 16),

          // Main Goal Card
          BaseContainer(
            child: Column(
              children: [
                Row(
                  children: [
                    _IconBox(icon: Icons.directions_car_filled_outlined),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('home_new_car'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('${'home_target_amount'.i18n()}: 8.500.000 Ft', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('5.525.000 Ft', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('home_saved_amount'.i18n(), style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Horizontal Stats
          Row(
            children: [
              Expanded(
                child: BaseContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('home_remaining_amount'.i18n(), style: theme.textTheme.labelSmall),
                      const SizedBox(height: 8),
                      Text('2.975.000 Ft', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BaseContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('home_expected_completion'.i18n(), style: theme.textTheme.labelSmall),
                      const SizedBox(height: 8),
                      Text('2025. Okt.',
                          style:
                              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple.shade300)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Text('home_monthly_performance'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Performance Grid
          BaseContainer(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              children: [
                _MonthStatus(month: 'Március', status: true),
                _MonthStatus(month: 'Április', status: true),
                _MonthStatus(month: 'Május', status: null),
                _MonthStatus(month: 'Június', status: true),
                _MonthStatus(month: 'Július', status: true),
                _MonthStatus(month: 'Augusztus', status: false, isCurrent: true),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('home_recent_transactions'.i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: Text('home_view_all'.i18n(), style: TextStyle(color: colorScheme.primary))),
            ],
          ),

          // Transaction List
          _TransactionTile(
              title: 'home_monthly_savings'.i18n(), date: 'Augusztus 12.', amount: '+150.000 Ft', icon: Icons.savings_outlined),
          const SizedBox(height: 12),
          _TransactionTile(
              title: 'home_bonus_deposit'.i18n(), date: 'Augusztus 05.', amount: '+45.000 Ft', icon: Icons.add_card_outlined),
          const SizedBox(height: 12),
          _TransactionTile(title: 'home_auto_transfer'.i18n(), date: 'Július 28.', amount: '+150.000 Ft', icon: Icons.history),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add, color: Colors.white),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
            color: isCurrent ? Colors.transparent : Colors.grey.withOpacity(0.1),
          ),
          child: Icon(
            status == true ? Icons.check : (status == false ? Icons.more_horiz : Icons.remove),
            color: isCurrent ? color : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
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
          const SizedBox(width: 16),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
