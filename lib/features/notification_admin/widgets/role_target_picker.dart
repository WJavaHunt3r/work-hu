import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';

/// Chooses who receives a notification: nobody selected means everyone.
class RoleTargetPicker extends ConsumerWidget {
  const RoleTargetPicker({super.key, required this.selected, required this.onChanged});

  final Set<num> selected;
  final void Function(Set<num>) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final roles = ref.watch(allRolesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("notification_admin_audience".i18n(), style: theme.textTheme.titleMedium),
        SizedBox(height: 4.sp),
        Text(
          selected.isEmpty ? "notification_admin_audience_all".i18n() : "notification_admin_audience_roles".i18n(),
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: 8.sp),
        roles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Text("api_unknown_error".i18n()),
          data: (list) => Wrap(
            spacing: 8.sp,
            children: [
              for (final role in list)
                FilterChip(
                  label: Text(role.name),
                  selected: selected.contains(role.id),
                  onSelected: (on) => onChanged(on ? {...selected, role.id!} : ({...selected}..remove(role.id))),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
