import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/change_password/data/state/change_password_state.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key, super.title = "change_password_viewname", super.canRefresh = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState
    extends BasePageState<ChangePasswordPage, ChangePasswordState, ChangePasswordDataNotifier> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _newPasswordAgainNode = FocusNode();

  @override
  void dispose() {
    _newPasswordAgainNode.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    var changed = await ref.read(changePasswordDataProvider.notifier).changePassword();
    if (!changed || !mounted) return;
    context.canPop() ? context.pop(true) : context.push("/login");
  }

  @override
  Widget buildLayout() {
    var notifier = ref.watch(changePasswordDataProvider.notifier);
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseTextFormField(
              obscureText: true,
              isPasswordField: true,
              controller: notifier.newPasswordController,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (text) => _newPasswordAgainNode.requestFocus(),
              labelText: "change_password_new_password".i18n(),
            ),
            BaseTextFormField(
              obscureText: true,
              focusNode: _newPasswordAgainNode,
              isPasswordField: true,
              controller: notifier.newPasswordAgainController,
              textInputAction: TextInputAction.go,
              labelText: "change_password_new_password_again".i18n(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: _changePassword, child: Text("change_password_change_action".i18n())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StateNotifierProvider<ChangePasswordDataNotifier, ChangePasswordState> get provider => changePasswordDataProvider;

  @override
  BaseState get status => state.status;
}
