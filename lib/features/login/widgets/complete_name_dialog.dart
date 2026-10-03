import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

/// The backend stores this instead of a name it doesn't know (e.g. Google sent no last name).
const _namePlaceholder = "-";

/// Wraps the signed-in area and, while the user's name is incomplete, shows [CompleteNameDialog] on top of it, then
/// [CompleteGenderDialog] while no gender is set (gender-restricted jobs need it).
/// Covers a fresh Google sign-in as well as a restored session of a user who never filled these in.
class CompleteNameGate extends ConsumerStatefulWidget {
  const CompleteNameGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CompleteNameGate> createState() => _CompleteNameGateState();
}

class _CompleteNameGateState extends ConsumerState<CompleteNameGate> {
  bool _dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider).user;
    final needsName = user != null && user.profileIncomplete;
    final needsGender = user != null && !needsName && user.gender == null;
    if ((needsName || needsGender) && !_dialogOpen) {
      _dialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => needsName ? const CompleteNameDialog() : const CompleteGenderDialog(),
        );
        _dialogOpen = false;
        // The user may still lack the other detail; look again.
        if (mounted) setState(() {});
      });
    }
    return widget.child;
  }
}

/// Small window asking for the last and first name, as the backend requires both. Can't be dismissed; the only
/// other way out is logging out.
class CompleteNameDialog extends ConsumerStatefulWidget {
  const CompleteNameDialog({super.key});

  @override
  ConsumerState<CompleteNameDialog> createState() => _CompleteNameDialogState();
}

class _CompleteNameDialogState extends ConsumerState<CompleteNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lastname;
  late final TextEditingController _firstname;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userDataProvider).user;
    // Keep the part Google did send.
    String known(String? name) => name == null || name == _namePlaceholder ? "" : name;
    _lastname = TextEditingController(text: known(user?.lastname));
    _firstname = TextEditingController(text: known(user?.firstname));
  }

  String? _validate(String? text) {
    final value = text?.trim() ?? "";
    if (value.isEmpty || value == _namePlaceholder) return "base_is_required".i18n();
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userProvider = ref.read(userDataProvider);
    final user = userProvider.user;
    if (user == null) return;
    setState(() => _saving = true);
    try {
      final updated = await guardApi(
        () => ref
            .read(usersRepoProvider)
            .updateUser(
              user.id,
              user.copyWith(
                lastname: _lastname.text.trim(),
                firstname: _firstname.text.trim(),
                profileIncomplete: false,
              ),
            ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      await userProvider.setUser(updated);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    final userProvider = ref.read(userDataProvider);
    Navigator.of(context).pop();
    await userProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text("complete_name_title".i18n()),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("complete_name_hint".i18n(), style: theme.textTheme.bodyMedium),
                SizedBox(height: 8.sp),
                BaseTextFormField(
                  controller: _lastname,
                  labelText: "complete_name_lastname".i18n(),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.familyName],
                  validator: _validate,
                ),
                BaseTextFormField(
                  controller: _firstname,
                  labelText: "complete_name_firstname".i18n(),
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.givenName],
                  validator: _validate,
                  onFieldSubmitted: (_) => _save(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: _saving ? null : _logout, child: Text("profile_logout".i18n())),
          FilledButton(onPressed: _saving ? null : _save, child: Text("base_save".i18n())),
        ],
      ),
    );
  }
}

/// Small window asking for the gender (Male/Female). Shown to users who have none, e.g. after signing up with Google.
/// Can't be dismissed; the only other way out is logging out.
class CompleteGenderDialog extends ConsumerStatefulWidget {
  const CompleteGenderDialog({super.key});

  @override
  ConsumerState<CompleteGenderDialog> createState() => _CompleteGenderDialogState();
}

class _CompleteGenderDialogState extends ConsumerState<CompleteGenderDialog> {
  Gender? _gender;
  bool _saving = false;

  Future<void> _save() async {
    final userProvider = ref.read(userDataProvider);
    final user = userProvider.user;
    if (user == null || _gender == null) return;
    setState(() => _saving = true);
    try {
      final updated = await guardApi(
        () => ref.read(usersRepoProvider).updateUser(user.id, user.copyWith(gender: _gender)),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      await userProvider.setUser(updated);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    final userProvider = ref.read(userDataProvider);
    Navigator.of(context).pop();
    await userProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text("complete_gender_title".i18n()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("complete_gender_hint".i18n(), style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16.sp),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Gender>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [for (final g in Gender.values) ButtonSegment(value: g, label: Text(g.label.i18n()))],
                selected: {if (_gender != null) _gender!},
                onSelectionChanged: (selection) => setState(() => _gender = selection.isEmpty ? null : selection.first),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: _saving ? null : _logout, child: Text("profile_logout".i18n())),
          FilledButton(onPressed: _saving || _gender == null ? null : _save, child: Text("base_save".i18n())),
        ],
      ),
    );
  }
}
