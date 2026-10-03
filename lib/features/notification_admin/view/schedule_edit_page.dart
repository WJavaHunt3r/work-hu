import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/notification_admin/data/model/notification_schedule_model.dart';
import 'package:work_hu/features/notification_admin/providers/notification_admin_provider.dart';
import 'package:work_hu/features/notification_admin/widgets/role_target_picker.dart';

const _days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];

/// Creates or edits a schedule. For the "on track" e-mail only day, time and active can be changed.
class ScheduleEditPage extends ConsumerStatefulWidget {
  const ScheduleEditPage({super.key, this.schedule});

  final NotificationScheduleModel? schedule;

  @override
  ConsumerState<ScheduleEditPage> createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends ConsumerState<ScheduleEditPage> {
  final _formKey = GlobalKey<FormState>();
  late NotificationScheduleModel _schedule = widget.schedule ?? const NotificationScheduleModel();
  late final _title = TextEditingController(text: _schedule.title ?? "");
  late final _body = TextEditingController(text: _schedule.body ?? "");
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  TimeOfDay get _time {
    final parts = _schedule.shortTime.split(':');
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 17, minute: int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    final text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    setState(() => _schedule = _schedule.copyWith(time: text));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final toSave = _schedule.isEmail
          ? _schedule
          : _schedule.copyWith(title: _title.text.trim(), body: _body.text.trim());
      await ref.read(notificationAdminRepoProvider).saveSchedule(toSave);
      if (mounted) context.pop(true);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? text) => text == null || text.trim().isEmpty ? "base_is_required".i18n() : null;
    final isEmail = _schedule.isEmail;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEmail
              ? "notification_type_ON_TRACK_EMAIL".i18n()
              : (widget.schedule == null ? "notification_admin_schedule_new" : "notification_admin_schedule_edit")
                    .i18n(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [TextButton(onPressed: _saving ? null : _save, child: Text("base_save".i18n()))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEmail) ...[
                BaseTextFormField(
                  controller: _title,
                  labelText: "notification_admin_title".i18n(),
                  inputFormatter: LengthLimitingTextInputFormatter(100),
                  validator: required,
                ),
                SizedBox(height: 8.sp),
                BaseTextFormField(
                  controller: _body,
                  labelText: "notification_admin_body".i18n(),
                  maxLines: 4,
                  inputFormatter: LengthLimitingTextInputFormatter(500),
                  validator: required,
                ),
                SizedBox(height: 16.sp),
              ],
              DropdownButtonFormField<String>(
                initialValue: _schedule.dayOfWeek,
                decoration: InputDecoration(labelText: "notification_admin_day".i18n()),
                items: [for (final d in _days) DropdownMenuItem(value: d, child: Text("weekday_$d".i18n()))],
                onChanged: (day) =>
                    setState(() => _schedule = _schedule.copyWith(dayOfWeek: day ?? _schedule.dayOfWeek)),
              ),
              SizedBox(height: 8.sp),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("notification_admin_time".i18n()),
                subtitle: Text("notification_admin_time_hint".i18n()),
                trailing: Text(_schedule.shortTime, style: Theme.of(context).textTheme.titleMedium),
                onTap: _pickTime,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("notification_admin_active".i18n()),
                value: _schedule.active,
                onChanged: (on) => setState(() => _schedule = _schedule.copyWith(active: on)),
              ),
              if (!isEmail) ...[
                SizedBox(height: 16.sp),
                RoleTargetPicker(
                  selected: {..._schedule.roleIds},
                  onChanged: (roles) => setState(() => _schedule = _schedule.copyWith(roleIds: roles.toList())),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
