import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';

/// Translated name of a permission, or the raw name for permissions this app version has no text for.
String permissionLabel(String name) {
  final key = "permission_$name";
  final text = key.i18n();
  return text == key ? name : text;
}

/// Creates or edits a role: name, description and a checkbox per permission.
class RoleEditPage extends ConsumerStatefulWidget {
  const RoleEditPage({super.key, this.role});

  final AppRoleModel? role;

  @override
  ConsumerState<RoleEditPage> createState() => _RoleEditPageState();
}

class _RoleEditPageState extends ConsumerState<RoleEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.role?.name ?? "");
  late final TextEditingController _description = TextEditingController(text: widget.role?.description ?? "");
  late final Set<String> _selected = {...?widget.role?.permissions};
  bool _saving = false;

  /// The ADMIN role is fixed in the backend; it is shown but can't be changed.
  bool get _readOnly => widget.role?.isAdminRole ?? false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_readOnly || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final role = (widget.role ?? const AppRoleModel(name: "")).copyWith(
        name: _name.text.trim(),
        description: _description.text.trim().isEmpty ? null : _description.text.trim(),
        permissions: _selected.toList()..sort(),
      );
      await ref.read(rolesRepoProvider).saveRole(role);
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
    final permissions = ref.watch(permissionNamesProvider);
    final builtInName = widget.role?.isBuiltIn ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.role == null ? "roles_new".i18n() : widget.role!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [if (!_readOnly) TextButton(onPressed: _saving ? null : _save, child: Text("base_save".i18n()))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseTextFormField(
                controller: _name,
                labelText: "roles_name".i18n(),
                enabled: !_readOnly && !builtInName,
                validator: (text) => text == null || text.trim().isEmpty ? "base_is_required".i18n() : null,
              ),
              SizedBox(height: 8.sp),
              BaseTextFormField(controller: _description, labelText: "roles_description".i18n(), enabled: !_readOnly),
              SizedBox(height: 16.sp),
              Text("roles_permissions".i18n(), style: Theme.of(context).textTheme.titleMedium),
              if (_readOnly) Text("roles_admin_fixed".i18n(), style: Theme.of(context).textTheme.bodySmall),
              permissions.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => Text("api_unknown_error".i18n()),
                data: (names) => Column(
                  children: [
                    for (final name in {...names, ..._selected})
                      CheckboxListTile(
                        value: _readOnly || _selected.contains(name),
                        title: Text(permissionLabel(name)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: _readOnly
                            ? null
                            : (checked) =>
                                  setState(() => checked == true ? _selected.add(name) : _selected.remove(name)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
