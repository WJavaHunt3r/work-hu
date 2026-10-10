import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/notification_admin/data/model/general_notification_model.dart';
import 'package:work_hu/features/notification_admin/providers/notification_admin_provider.dart';
import 'package:work_hu/features/notification_admin/widgets/role_target_picker.dart';
import 'package:work_hu/app/platform/adaptive.dart';

/// Composes and sends a one-off push to everyone or to the users of the chosen roles. Sending is immediate, so it
/// asks for confirmation first.
class SendNotificationPage extends ConsumerStatefulWidget {
  const SendNotificationPage({super.key});

  @override
  ConsumerState<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends ConsumerState<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  Set<num> _roles = {};
  bool _sending = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: Text("notification_admin_confirm_title".i18n()),
        content: Text(
          _roles.isEmpty ? "notification_admin_confirm_all".i18n() : "notification_admin_confirm_roles".i18n(),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => context.pop(true), child: Text("notification_admin_send".i18n())),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _sending = true);
    try {
      final result = await ref
          .read(notificationAdminRepoProvider)
          .sendGeneral(
            GeneralNotificationModel(title: _title.text.trim(), body: _body.text.trim(), roleIds: _roles.toList()),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "notification_admin_result".i18n(["${result.delivered}", "${result.recipientUsers}", "${result.failed}"]),
          ),
        ),
      );
      context.pop(true);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? text) => text == null || text.trim().isEmpty ? "base_is_required".i18n() : null;
    return Scaffold(
      appBar: AppBar(
        title: Text("notification_admin_new".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [TextButton(onPressed: _sending ? null : _send, child: Text("notification_admin_send".i18n()))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 24.sp),
              RoleTargetPicker(selected: _roles, onChanged: (roles) => setState(() => _roles = roles)),
            ],
          ),
        ),
      ),
    );
  }
}
