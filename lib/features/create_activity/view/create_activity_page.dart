import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/features/create_activity/data/state/create_activity_state.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/widgets/registration_row_widget.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';
import 'package:work_hu/features/utils.dart';

class CreateActivityPage extends BasePage {
  const CreateActivityPage(
      {super.title = "create_activity_new_activity_viewname",
      super.key,
      super.canPop = false,
      super.canRefresh = false,
      this.id});

  final num? id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CreateActivityPageState();
  }
}

class CreateActivityPageState extends BasePageState<CreateActivityPage, CreateActivityState, CreateActivityDataNotifier> {
  static final _formKey = GlobalKey<FormState>();
  late final TextEditingController hoursController;
  late final TextEditingController defaultHourController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  late final TextEditingController userController;
  late final TextEditingController responsibleController;
  late final TextEditingController employerController;
  late final FocusNode valueFocusNode;
  late final FocusScopeNode usersFocusNode;

  @override
  void initState() {
    super.initState();
    hoursController = TextEditingController(text: "");
    userController = TextEditingController(text: "");
    defaultHourController = TextEditingController(text: "1");
    employerController = TextEditingController(text: "");
    responsibleController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: DateTime.now().toString());
    valueFocusNode = FocusNode();
    usersFocusNode = FocusScopeNode();

    dateController.addListener(() => ref.watch(provider.notifier).updateActivity(
        state.activity!.copyWith(activityDateTime: DateTime.tryParse(dateController.value.text) ?? DateTime.now())));
    descriptionController.addListener(() =>
        ref.watch(provider.notifier).updateActivity(state.activity!.copyWith(description: descriptionController.value.text)));
    hoursController.addListener(() => ref.read(provider.notifier).updateHours(hoursController.value.text));
    userController.addListener(() => _scrollToTop());

    defaultHourController.addListener(() {
      ref.read(provider.notifier).updateDefaultHour(defaultHourController.value.text);
      hoursController.text = defaultHourController.value.text;
    });
  }

  @override
  void postInit(WidgetRef ref) {
    super.postInit(ref);
    if (widget.id != null) {
      ref.read(provider.notifier).getActivity(widget.id!).then((value) {
        if (state.status.modelState.isSuccess && state.activity != null) {
          dateController.text = state.activity!.activityDateTime.toString();
          descriptionController.text = state.activity!.description;
        }
      });
    } else {
      ref.read(provider.notifier).presetActivity();
    }
  }

  @override
  Widget buildLayout() {
    var theme = Theme.of(context);
    return state.activity == null
        ? const SizedBox()
        : Column(
            children: [
              _buildDetails(theme),
              SizedBox(height: 5.sp),
              if (state.activity!.description.isNotEmpty) _buildSummaryCard(theme),
              SizedBox(height: 5.sp),
              if (state.activity!.description.isNotEmpty) _buildRegistrationCard(theme),
              SizedBox(height: 5.sp),
              if (state.activity!.description.isNotEmpty) _buildRegistrationListCard(theme)
            ],
          );
  }

  _buildDetails(ThemeData theme) {
    return BaseContainer(
        padding: EdgeInsets.all(8.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseTextFormField(
                controller: dateController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                labelText: "create_activity_activity_date".i18n(),
                suffix: IconButton(
                  onPressed: () => _selectDate(context, ref),
                  icon: const Icon(Icons.calendar_month),
                ),
              ),
              SizedBox(height: 5.sp),
              BaseTextFormField(
                controller: descriptionController,
                labelText: "create_activity_description".i18n(),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'create_activity_description_error'.i18n();
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 5.sp),
              UserComboWidget(
                controller: employerController,
                initValue: 281,
                onSuggestionSelected: (UserComboModel suggestion) {
                  ref.watch(provider.notifier).updateActivity(state.activity!.copyWith(employerId: suggestion.id));
                },
                labelText: "create_activity_employer".i18n(),
              ),
              UserComboWidget(
                controller: responsibleController,
                initValue: state.activity!.responsibleId,
                onSuggestionSelected: (UserComboModel suggestion) {
                  ref.watch(provider.notifier).updateActivity(state.activity!.copyWith(responsibleId: suggestion.id));
                },
                labelText: "create_activity_responsible".i18n(),
              ),
              SizedBox(height: 5.sp),
              state.activity!.employerId == 281
                  ? Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          constraints: constraints,
                          child: DropdownButtonFormField(
                              alignment: AlignmentDirectional.topStart,
                              borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                              decoration: InputDecoration(
                                labelText: "create_activity_transaction_type".i18n(),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.sp)),
                              ),
                              initialValue: state.activity!.transactionType,
                              items: [TransactionType.DUKA_MUNKA_2000, TransactionType.DUKA_MUNKA]
                                  .map((e) => DropdownMenuItem<TransactionType>(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChanged: (value) => value != null ? ref.watch(provider.notifier).updateAccount(value) : null),
                        );
                      }),
                    )
                  : const SizedBox(),
              SizedBox(
                width: 140.sp,
                child: BaseTextFormField(
                  controller: defaultHourController,
                  inputFormatter: CommaToDotFormatter(),
                  keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  labelText: "create_activity_default_hour".i18n(),
                ),
              ),
              state.activity!.description.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "create_activity_description_error".i18n(),
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null && context.mounted) {
      final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      if (time != null) {
        var dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        dateController.text = dateTime.toString();
      }
    }
  }

  @override
  AutoDisposeStateNotifierProvider<CreateActivityDataNotifier, CreateActivityState> get provider => createActivityDataProvider;

  @override
  BaseState get status => state.status;
  final GlobalKey _fieldKey = GlobalKey();

  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_fieldKey.currentContext != null) {
        Scrollable.ensureVisible(
          _fieldKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1.sp,
        );
      }
    });
  }

  _buildRegistrationCard(ThemeData theme) {
    return BaseContainer(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: UserComboWidget(
                key: _fieldKey,
                controller: userController,
                focusNode: usersFocusNode,
                onSuggestionSelected: (UserComboModel suggestion) {
                  ref.read(provider.notifier).updateSelectedUser(suggestion);
                  valueFocusNode.requestFocus();
                },
                labelText: "create_activity_user".i18n(),
              ),
            ),
            SizedBox(width: 10.sp),
            SizedBox(
              width: 140.sp,
              child: BaseTextFormField(
                controller: hoursController,
                inputFormatter: CommaToDotFormatter(),
                keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                focusNode: valueFocusNode,
                suffix: Padding(
                  padding: EdgeInsets.zero,
                  child: FilledButton(
                      onPressed: state.selectedUser != null && state.hours != null
                          ? () {
                              addRegistration();
                            }
                          : null,
                      child: const Icon(
                        Icons.add,
                      )),
                ),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: state.selectedUser != null && state.hours != null ? (text) => addRegistration() : null,
                labelText: Utils.getTransactionTypeText(TransactionType.HOURS),
              ),
            ),
          ],
        ));
  }

  addRegistration() {
    ref.read(provider.notifier).addRegistration(hours: double.tryParse(hoursController.text.replaceAll(",", ".")) ?? 0);
    _clearControllers();
    usersFocusNode.requestFocus();
  }

  _buildSummaryCard(ThemeData theme) {
    var sum = state.sum;
    return BaseContainer(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("create_activity_count".i18n()),
                Text(
                  state.activityItems.length.toStringAsFixed(0),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                Text("create_activity_sum".i18n([Utils.getTransactionTypeText(state.activity!.transactionType, false)])),
                Text(
                  sum % 1 == 0 ? sum.toStringAsFixed(0) : sum.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(state.activity!.account == Account.MYSHARE && TransactionType.HOURS == (state.activity!.transactionType)
                    ? " (${(sum * 3000).toInt()} Ft)"
                    : TransactionType.DUKA_MUNKA_2000 == (state.activity!.transactionType)
                        ? " (${(sum * 2000).toInt()} Ft)"
                        : state.activity!.account == Account.MYSHARE &&
                                state.activity!.transactionType == TransactionType.DUKA_MUNKA
                            ? " (${(sum * 1000).toInt()} Ft)"
                            : "")
              ],
            ),
            FilledButton(
                onPressed: () => ref.watch(provider.notifier).isEmpty()
                    ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorAlertDialog(title: "create_activity_warning".i18n());
                        })
                    : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmAlertDialog(
                                onConfirm: () {
                                  Navigator.of(context).pop(true);
                                },
                                title: "create_confirm_activity_send".i18n(),
                                content: Text("create_confirm_activity_send_question".i18n(), textAlign: TextAlign.center),
                              );
                            })
                        .then((value) => value != null && value == true
                            ? ref
                                .read(provider.notifier)
                                .sendActivity()
                                .then((r) => state.status.modelState.isSuccess ? Navigator.of(context).pop() : null)
                            : null),
                child: Text("create_activity_send".i18n()))
          ],
        ));
  }

  Widget _buildRegistrationListCard(ThemeData theme) {
    var items = state.activityItems;
    return Padding(
      padding: EdgeInsets.only(bottom: 400.sp),
      child: state.activityItems.isEmpty
          ? const SizedBox()
          : Column(
              children: items.map((e) {
              var user = e.userName;
              return Material(
                surfaceTintColor: Colors.transparent,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24.sp),
                child: RegistrationRowWidget(
                  name: user,
                  index: items.indexOf(e),
                  isLast: items.indexOf(e) == items.length - 1,
                  value: e.hours,
                  onTap: () {},
                ),
              );
            }).toList()),
    );
  }

  _clearControllers() {
    hoursController.text = defaultHourController.text;
    userController.clear();
  }
}
