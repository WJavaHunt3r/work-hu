import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/widgets/base_form_field.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

/// The "add user" form of the users admin. The backend makes the username and MyShare id and e-mails the new user
/// a temporary password, which they must change when they first sign in. Pops `true` when a user was created.
class UserCreateDialog extends ConsumerStatefulWidget {
  const UserCreateDialog({super.key});

  @override
  ConsumerState<UserCreateDialog> createState() => _UserCreateDialogState();
}

class _UserCreateDialogState extends ConsumerState<UserCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _lastname = TextEditingController();
  final _firstname = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  DateTime? _birthDate;
  Gender? _gender;
  bool _member = false;
  bool _saving = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    for (final c in [_lastname, _firstname, _email, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) => (value ?? "").trim().isEmpty ? "user_create_required".i18n() : null;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await pickDate(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final created = await ref.read(userDetailProvider.notifier).createUser({
      "lastname": _lastname.text.trim(),
      "firstname": _firstname.text.trim(),
      "email": _email.text.trim(),
      "birthDate": _birthDate == null ? null : Utils.dateTimeToDateOnlyString(_birthDate),
      "gender": _gender?.name,
      "phoneNumber": num.tryParse(_phone.text.trim()),
      "member": _member,
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (created == null) return; // the reason was shown
    final message = created.emailSent ? "user_create_done" : "user_create_done_no_mail";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.i18n([created.user.getFullName()]))));
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
          title: Text("user_create_title".i18n(), style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: [TextButton(onPressed: _saving ? null : _save, child: Text("user_create_save".i18n()))],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.sp),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        labelText: "user_details_lastname",
                        controller: _lastname,
                        fldControl: "3", // the widget only runs the validator with this

                        validator: _required,
                      ),
                    ),
                    SizedBox(width: 5.sp),
                    Expanded(
                      child: BaseTextFormField(
                        labelText: "user_details_firstname",
                        controller: _firstname,
                        fldControl: "3", // the widget only runs the validator with this

                        validator: _required,
                      ),
                    ),
                  ],
                ),
                BaseTextFormField(
                  labelText: "user_details_email",
                  controller: _email,
                  keyBoardType: TextInputType.emailAddress,
                  fldControl: "3", // the widget only runs the validator with this

                  validator: (v) =>
                      _emailPattern.hasMatch((v ?? "").trim()) ? null : "user_create_email_invalid".i18n(),
                ),
                BaseLabeledField(
                  labelText: "user_details_date_of_birth".i18n(),
                  child: InkWell(
                    onTap: _pickBirthDate,
                    child: InputDecorator(
                      decoration: baseInputDecoration(
                        Theme.of(context),
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(_birthDate == null ? " " : Utils.dateTimeToDateOnlyString(_birthDate)),
                    ),
                  ),
                ),
                BaseDropdownFormField<Gender?>(
                  labelText: "user_details_gender",
                  initialValue: _gender,
                  items: [
                    const DropdownMenuItem<Gender?>(value: null, child: Text("")),
                    ...Gender.values.map((e) => DropdownMenuItem<Gender?>(value: e, child: Text(e.label.i18n()))),
                  ],
                  onChanged: (value) => setState(() => _gender = value),
                ),
                BaseTextFormField(
                  labelText: "user_details_phone_number",
                  controller: _phone,
                  keyBoardType: TextInputType.number,
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                  title: Text("user_details_member".i18n()),
                  subtitle: Text("user_details_member_hint".i18n()),
                  value: _member,
                  onChanged: (value) => setState(() => _member = value),
                ),
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Text("user_create_hint".i18n(), style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
