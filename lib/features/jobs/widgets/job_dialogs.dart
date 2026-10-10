import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/jobs/data/model/job_hours_entry.dart';
import 'package:work_hu/features/jobs/data/model/job_registration_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';
import 'package:work_hu/app/platform/adaptive.dart';

/// Asks for the (optional) comment of a registration. Returns null when cancelled, otherwise the text (maybe empty).
Future<String?> showCommentDialog(BuildContext context, {required String title, String? initial}) {
  final controller = TextEditingController(text: initial ?? "");
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AdaptiveAlertDialog(
      title: Text(title.i18n()),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 500,
        maxLines: 3,
        decoration: InputDecoration(labelText: "jobs_comment".i18n(), hintText: "jobs_comment_hint".i18n()),
      ),
      actions: [
        TextButton(onPressed: () => dialogContext.pop(), child: Text("base_cancel".i18n())),
        FilledButton(onPressed: () => dialogContext.pop(controller.text.trim()), child: Text("base_ok".i18n())),
      ],
    ),
  );
}

/// Picks the user to register and an optional comment. Returns null when cancelled.
class JobRegisterSomeoneDialog extends StatefulWidget {
  const JobRegisterSomeoneDialog({super.key});

  @override
  State<JobRegisterSomeoneDialog> createState() => _JobRegisterSomeoneDialogState();
}

class _JobRegisterSomeoneDialogState extends State<JobRegisterSomeoneDialog> {
  // Disposed with the dialog, not when showDialog returns: the closing animation still uses them.
  final _user = TextEditingController();
  final _comment = TextEditingController();
  UserComboModel? _selected;

  @override
  void dispose() {
    _user.dispose();
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    final comment = _comment.text.trim();
    Navigator.of(context).pop((user: _selected!, comment: comment.isEmpty ? null : comment));
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveAlertDialog(
      title: Text("jobs_register_someone".i18n()),
      // AlertDialog sizes its content with IntrinsicWidth, which the user picker's LayoutBuilder can't answer;
      // a fixed width means the content is never asked.
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserComboWidget(
              controller: _user,
              labelText: "jobs_user".i18n(),
              onSuggestionSelected: (user) => setState(() => _selected = user),
            ),
            TextField(
              controller: _comment,
              maxLength: 500,
              decoration: InputDecoration(labelText: "jobs_comment".i18n()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("base_cancel".i18n())),
        FilledButton(onPressed: _selected == null ? null : _submit, child: Text("base_ok".i18n())),
      ],
    );
  }
}

/// Hours per registered user, to complete a job. Returns the entries, or null when cancelled.
class JobCompleteDialog extends StatefulWidget {
  const JobCompleteDialog({super.key, required this.registrations, this.defaultHours = 1});

  /// The users who were registered (not waitlisted).
  final List<JobRegistrationModel> registrations;

  /// The hours every user starts with.
  final double defaultHours;

  @override
  State<JobCompleteDialog> createState() => _JobCompleteDialogState();
}

class _JobCompleteDialogState extends State<JobCompleteDialog> {
  final _formKey = GlobalKey<FormState>();

  /// 2 shows as "2", 1.5 as "1.5".
  late final String _initialHours = widget.defaultHours.toString().replaceFirst(RegExp(r'\.0$'), "");
  late final _defaultHours = TextEditingController(text: _initialHours);
  late final Map<num, TextEditingController> _hours = {
    for (final r in widget.registrations) r.userId: TextEditingController(text: _initialHours),
  };

  /// People who came without being registered; they get hours too. Keyed by user id, in the order added.
  final Map<num, ({String name, TextEditingController hours})> _extras = {};
  final _extraPicker = TextEditingController();

  @override
  void dispose() {
    _defaultHours.dispose();
    for (final c in _hours.values) {
      c.dispose();
    }
    for (final extra in _extras.values) {
      extra.hours.dispose();
    }
    _extraPicker.dispose();
    super.dispose();
  }

  double? _parse(String text) => double.tryParse(text.trim().replaceAll(",", "."));

  void _applyDefault() {
    for (final c in _hours.values) {
      c.text = _defaultHours.text;
    }
    for (final extra in _extras.values) {
      extra.hours.text = _defaultHours.text;
    }
  }

  void _addExtra(UserComboModel user) {
    // Someone already in the list (registered or added) is not added twice.
    if (!_hours.containsKey(user.id) && !_extras.containsKey(user.id)) {
      _extras[user.id] = (name: user.getFullName(), hours: TextEditingController(text: _defaultHours.text));
    }
    _extraPicker.clear();
    setState(() {});
  }

  String? _hoursValidator(String? text) {
    final hours = _parse(text ?? "");
    return hours == null || hours < 0 ? "base_is_required".i18n() : null;
  }

  void _submit() {
    if ((widget.registrations.isEmpty && _extras.isEmpty) || !_formKey.currentState!.validate()) return;
    context.pop([
      for (final r in widget.registrations) JobHoursEntry(userId: r.userId, hours: _parse(_hours[r.userId]!.text) ?? 0),
      for (final e in _extras.entries) JobHoursEntry(userId: e.key, hours: _parse(e.value.hours.text) ?? 0),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
          title: Text("jobs_complete_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [TextButton(onPressed: _submit, child: Text("jobs_complete_submit".i18n()))],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("jobs_complete_hint".i18n(), style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8.sp),
                Row(
                  children: [
                    SizedBox(
                      width: 140.sp,
                      child: BaseTextFormField(
                        controller: _defaultHours,
                        inputFormatter: CommaToDotFormatter(),
                        keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                        labelText: "jobs_complete_default_hours".i18n(),
                        onChanged: (_) => _applyDefault(),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                if (widget.registrations.isEmpty && _extras.isEmpty) Text("jobs_complete_nobody".i18n()),
                for (final r in widget.registrations)
                  Row(
                    children: [
                      Expanded(child: Text(r.userName ?? "${r.userId}")),
                      SizedBox(
                        width: 120.sp,
                        child: BaseTextFormField(
                          controller: _hours[r.userId],
                          inputFormatter: CommaToDotFormatter(),
                          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                          labelText: "base_text_hours".i18n(),
                          validator: _hoursValidator,
                        ),
                      ),
                    ],
                  ),
                for (final e in _extras.entries)
                  Row(
                    children: [
                      Expanded(child: Text(e.value.name)),
                      SizedBox(
                        width: 120.sp,
                        child: BaseTextFormField(
                          controller: e.value.hours,
                          inputFormatter: CommaToDotFormatter(),
                          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                          labelText: "base_text_hours".i18n(),
                          validator: _hoursValidator,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: "base_delete".i18n(),
                        onPressed: () {
                          final removed = _extras.remove(e.key);
                          setState(() {});
                          // After the frame: the field still uses the controller while it is being removed.
                          WidgetsBinding.instance.addPostFrameCallback((_) => removed?.hours.dispose());
                        },
                      ),
                    ],
                  ),
                const Divider(),
                Text("jobs_complete_add_user".i18n(), style: Theme.of(context).textTheme.titleSmall),
                Text("jobs_complete_add_user_hint".i18n(), style: Theme.of(context).textTheme.bodySmall),
                UserComboWidget(
                  controller: _extraPicker,
                  labelText: "jobs_user".i18n(),
                  onSuggestionSelected: _addExtra,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
