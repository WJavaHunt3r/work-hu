import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_form_field.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/model/job_recurrence_model.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';
import 'package:work_hu/features/utils.dart';

/// Creates a job, or edits the one with [jobId].
///
/// Same employer rule as "create activity": only that employer chooses a paid-activity type, everything else is HOURS.
class JobFormPage extends ConsumerStatefulWidget {
  const JobFormPage({super.key, this.jobId});

  final num? jobId;

  /// The employer that offers the Duka work transaction types (see CreateActivityPage).
  static const dukaEmployerId = 281;

  @override
  ConsumerState<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends ConsumerState<JobFormPage> {
  static const _defaultDuration = Duration(hours: 2);

  /// The backend's limit for one repeating job.
  static const _maxOccurrences = 60;

  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _employer = TextEditingController();
  final _responsible = TextEditingController();
  final _maxParticipants = TextEditingController();
  final _minAge = TextEditingController();
  final _maxAge = TextEditingController();

  late DateTime _jobDateTime;
  late DateTime _jobEndDateTime;
  late DateTime _registrationDeadline;
  late DateTime _cancellationDeadline;
  _RegStart _regStart = _RegStart.open;
  _RegDeadline _regDeadline = _RegDeadline.startDate;
  _CancelDeadline _cancelDeadline = _CancelDeadline.registrationDeadline;

  num? _employerId;
  num? _responsibleId;
  TransactionType _transactionType = TransactionType.HOURS;
  Account _account = Account.MYSHARE;
  bool _waitlist = false;
  Gender? _gender;

  /// Used when the registration start is "Select date".
  late DateTime _registrationOpensAt;
  bool _sendNotification = true;

  // Repeat (creating only)
  _Repeat _repeat = _Repeat.none;
  final Set<int> _repeatDays = {};
  late DateTime _repeatUntil = DateTime.now().add(const Duration(days: 35));

  /// Edit mode shows the form once the job is loaded, so the user pickers can start with its values.
  bool _loaded = false;
  bool _saving = false;
  JobModel? _existing;

  @override
  void initState() {
    super.initState();
    final start = DateTime.now().add(const Duration(days: 7));
    _setJobDateTime(DateTime(start.year, start.month, start.day, 9));
    _jobEndDateTime = _jobDateTime.add(_defaultDuration);
    _registrationDeadline = _jobDateTime.subtract(const Duration(days: 1));
    _cancellationDeadline = _jobDateTime.subtract(const Duration(days: 1));
    _registrationOpensAt = _jobDateTime.subtract(const Duration(days: 7));
    if (widget.jobId == null) {
      _responsibleId = ref.read(userDataProvider).user?.id;
      _loaded = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  @override
  void dispose() {
    for (final c in [_description, _employer, _responsible, _maxParticipants, _minAge, _maxAge]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExisting() async {
    try {
      final job = await ref.read(jobRepoProvider).getJob(widget.jobId!);
      if (!mounted) return;
      setState(() {
        _existing = job;
        _description.text = job.description;
        _jobDateTime = job.jobDateTime;
        _jobEndDateTime = job.jobEndDateTime ?? job.jobDateTime.add(_defaultDuration);
        _loadWindow(job);
        _employerId = job.employerId;
        _responsibleId = job.responsibleId;
        _transactionType = job.transactionType;
        _account = job.account;
        _waitlist = job.waitlistEnabled;
        _gender = job.genderRestriction;
        _sendNotification = job.sendNotification;
        _maxParticipants.text = job.maxParticipants?.toString() ?? "";
        _minAge.text = job.minAge?.toString() ?? "";
        _maxAge.text = job.maxAge?.toString() ?? "";
        _normalizeTransactionType();
        _loaded = true;
      });
    } on ApiException catch (e) {
      showApiError(e.message);
      if (mounted) context.pop();
    } catch (_) {
      showApiError("api_unknown_error".i18n());
      if (mounted) context.pop();
    }
  }

  /// Only the Duka employer chooses between the Duka work types; for everyone else the job is paid by the hour.
  void _normalizeTransactionType() {
    final duka = _employerId == JobFormPage.dukaEmployerId;
    final isDukaType =
        _transactionType == TransactionType.DUKA_MUNKA || _transactionType == TransactionType.DUKA_MUNKA_2000;
    if (duka && !isDukaType) _transactionType = TransactionType.DUKA_MUNKA_2000;
    if (!duka) _transactionType = TransactionType.HOURS;
  }

  /// Choices that follow the job ("Start date", "End date") are resolved when saving, so they move with it.
  void _setJobDateTime(DateTime value) {
    // The end keeps its distance to the start when the start moves.
    if (_loaded) _jobEndDateTime = value.add(_jobEndDateTime.difference(_jobDateTime));
    _jobDateTime = value;
  }

  /// Picks the dropdown choices that describe an existing job's registration window.
  void _loadWindow(JobModel job) {
    _regStart = job.registrationClosed
        ? _RegStart.closed
        : job.registrationOpensAt != null
        ? _RegStart.date
        : _RegStart.open;
    if (job.registrationOpensAt != null) _registrationOpensAt = job.registrationOpensAt!;

    final regDeadline = job.registrationDeadline;
    _regDeadline = regDeadline == null
        ? _RegDeadline.none
        : regDeadline == job.jobDateTime
        ? _RegDeadline.startDate
        : _RegDeadline.date;
    if (regDeadline != null) _registrationDeadline = regDeadline;

    final cancel = job.cancellationDeadline;
    _cancelDeadline = !job.cancellationAllowed
        ? _CancelDeadline.notAllowed
        : cancel == null
        ? _CancelDeadline.none
        : cancel == job.jobDateTime
        ? _CancelDeadline.startDate
        : cancel == job.jobEndDateTime
        ? _CancelDeadline.endDate
        : cancel == regDeadline
        ? _CancelDeadline.registrationDeadline
        : _CancelDeadline.date;
    if (cancel != null) _cancellationDeadline = cancel;
  }

  /// The registration deadline the current choice stands for; null = none.
  DateTime? get _resolvedRegistrationDeadline => switch (_regDeadline) {
    _RegDeadline.startDate => _jobDateTime,
    _RegDeadline.none => null,
    _RegDeadline.date => _registrationDeadline,
  };

  DateTime? get _resolvedCancellationDeadline => switch (_cancelDeadline) {
    _CancelDeadline.notAllowed || _CancelDeadline.none => null,
    _CancelDeadline.registrationDeadline => _resolvedRegistrationDeadline,
    _CancelDeadline.startDate => _jobDateTime,
    _CancelDeadline.endDate => _jobEndDateTime,
    _CancelDeadline.date => _cancellationDeadline,
  };

  DateTime? get _resolvedOpensAt => _regStart == _RegStart.date ? _registrationOpensAt : null;

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30)),
      lastDate: DateTime(now.year + 2, 12, 31),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static const _dayNames = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];

  /// Weekdays (DateTime.monday = 1 ... sunday = 7) that get a job, depending on the repeat mode.
  Set<int> get _effectiveDays => _repeat == _Repeat.weekly ? {_jobDateTime.weekday} : _repeatDays;

  /// Dates from the job date to the repeat end whose weekday is selected.
  int get _occurrenceCount {
    if (_repeat == _Repeat.none) return 1;
    var date = DateTime(_jobDateTime.year, _jobDateTime.month, _jobDateTime.day);
    final until = DateTime(_repeatUntil.year, _repeatUntil.month, _repeatUntil.day);
    var count = 0;
    while (!date.isAfter(until) && count <= 1000) {
      if (_effectiveDays.contains(date.weekday)) count++;
      date = DateTime(date.year, date.month, date.day + 1);
    }
    return count;
  }

  int? _int(TextEditingController controller) => int.tryParse(controller.text.trim());

  String? _validateForm() {
    if (_employerId == null) return "jobs_form_employer_missing".i18n();
    if (_responsibleId == null) return "jobs_form_responsible_missing".i18n();
    if (!_jobEndDateTime.isAfter(_jobDateTime)) return "jobs_form_end_before_start".i18n();
    final registrationDeadline = _resolvedRegistrationDeadline;
    final cancellationDeadline = _resolvedCancellationDeadline;
    if (registrationDeadline != null && registrationDeadline.isAfter(_jobDateTime)) {
      return "jobs_form_deadline_after_job".i18n();
    }
    if (cancellationDeadline != null && cancellationDeadline.isAfter(_jobEndDateTime)) {
      return "jobs_form_deadline_after_job".i18n();
    }
    final opensAt = _resolvedOpensAt;
    if (opensAt != null && registrationDeadline != null && opensAt.isAfter(registrationDeadline)) {
      return "jobs_form_opens_after_deadline".i18n();
    }
    final min = _int(_minAge);
    final max = _int(_maxAge);
    if (min != null && max != null && min > max) return "jobs_form_age_range".i18n();
    if (widget.jobId == null && _repeat != _Repeat.none) {
      if (_effectiveDays.isEmpty) return "jobs_repeat_no_days".i18n();
      if (_occurrenceCount == 0) return "jobs_repeat_no_match".i18n();
      if (_occurrenceCount > _maxOccurrences) return "jobs_repeat_too_many".i18n([_maxOccurrences.toString()]);
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final problem = _validateForm();
    if (problem != null) {
      showApiError(problem);
      return;
    }
    setState(() => _saving = true);
    try {
      final base =
          _existing ??
          JobModel(
            jobDateTime: _jobDateTime,
            description: "",
            employerId: _employerId!,
            responsibleId: _responsibleId!,
            account: _account,
            transactionType: _transactionType,
          );
      final job = base.copyWith(
        jobDateTime: _jobDateTime,
        jobEndDateTime: _jobEndDateTime,
        description: _description.text.trim(),
        employerId: _employerId!,
        responsibleId: _responsibleId!,
        account: _account,
        transactionType: _transactionType,
        registrationOpensAt: _resolvedOpensAt,
        registrationClosed: _regStart == _RegStart.closed,
        sendNotification: _sendNotification,
        registrationDeadline: _resolvedRegistrationDeadline,
        cancellationDeadline: _resolvedCancellationDeadline,
        cancellationAllowed: _cancelDeadline != _CancelDeadline.notAllowed,
        maxParticipants: _int(_maxParticipants),
        waitlistEnabled: _waitlist,
        minAge: _int(_minAge),
        maxAge: _int(_maxAge),
        genderRestriction: _gender,
        recurrence: widget.jobId == null && _repeat != _Repeat.none
            ? JobRecurrenceModel(
                daysOfWeek: ([..._effectiveDays]..sort()).map((d) => _dayNames[d - 1]).toList(),
                repeatUntil: _repeatUntil,
              )
            : null,
      );
      await ref.read(jobRepoProvider).saveJob(job);
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
    final editing = widget.jobId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (editing ? "jobs_edit" : "jobs_new").i18n(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [TextButton(onPressed: _saving || !_loaded ? null : _save, child: Text("base_save".i18n()))],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildBasics(),
                    if (!editing) ...[SizedBox(height: 12.sp), _buildRepeat()],
                    SizedBox(height: 12.sp),
                    _buildLimits(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBasics() {
    final theme = Theme.of(context);
    return BaseContainer(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseTextFormField(
            controller: _description,
            labelText: "jobs_description".i18n(),
            textInputAction: TextInputAction.next,
            validator: (text) => text == null || text.trim().isEmpty ? "jobs_form_description_missing".i18n() : null,
          ),
          _DateTimeField(
            label: "jobs_date",
            value: _jobDateTime,
            onTap: () async {
              final picked = await _pickDateTime(_jobDateTime);
              if (picked != null) setState(() => _setJobDateTime(picked));
            },
          ),
          _DateTimeField(
            label: "jobs_end",
            value: _jobEndDateTime,
            onTap: () async {
              final picked = await _pickDateTime(_jobEndDateTime);
              if (picked != null) setState(() => _jobEndDateTime = picked);
            },
          ),
          UserComboWidget(
            controller: _employer,
            initValue: _employerId,
            labelText: "jobs_employer".i18n(),
            onSuggestionSelected: (UserComboModel user) => setState(() {
              _employerId = user.id;
              _normalizeTransactionType();
            }),
          ),
          UserComboWidget(
            controller: _responsible,
            initValue: _responsibleId,
            labelText: "jobs_responsible".i18n(),
            onSuggestionSelected: (UserComboModel user) => _responsibleId = user.id,
          ),
          if (_employerId == JobFormPage.dukaEmployerId)
            BaseDropdownFormField<TransactionType>(
              labelText: "create_activity_transaction_type",
              initialValue: _transactionType,
              items: [
                TransactionType.DUKA_MUNKA_2000,
                TransactionType.DUKA_MUNKA,
              ].map((e) => DropdownMenuItem<TransactionType>(value: e, child: Text(e.name))).toList(),
              onChanged: (value) => value == null ? null : setState(() => _transactionType = value),
            ),
          SizedBox(height: 4.sp),
          SizedBox(height: 4.sp),
          Text("jobs_registration_window".i18n(), style: theme.textTheme.titleSmall),
          BaseDropdownFormField<_RegStart>(
            labelText: "jobs_registration_start",
            initialValue: _regStart,
            items: [for (final e in _RegStart.values) DropdownMenuItem(value: e, child: Text(e.label.i18n()))],
            onChanged: (value) => value == null ? null : setState(() => _regStart = value),
          ),
          if (_regStart == _RegStart.date)
            _DateTimeField(
              label: "jobs_registration_opens",
              value: _registrationOpensAt,
              onTap: () async {
                final picked = await _pickDateTime(_registrationOpensAt);
                if (picked != null) setState(() => _registrationOpensAt = picked);
              },
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
            title: Text("jobs_send_notification".i18n()),
            subtitle: Text(
              (_regStart == _RegStart.date ? "jobs_send_notification_scheduled" : "jobs_send_notification_now").i18n(),
            ),
            value: _sendNotification,
            onChanged: (on) => setState(() => _sendNotification = on),
          ),
          BaseDropdownFormField<_RegDeadline>(
            labelText: "jobs_registration_deadline",
            initialValue: _regDeadline,
            items: [for (final e in _RegDeadline.values) DropdownMenuItem(value: e, child: Text(e.label.i18n()))],
            onChanged: (value) => value == null ? null : setState(() => _regDeadline = value),
          ),
          if (_regDeadline == _RegDeadline.date)
            _DateTimeField(
              label: "jobs_registration_deadline",
              value: _registrationDeadline,
              onTap: () async {
                final picked = await _pickDateTime(_registrationDeadline);
                if (picked != null) setState(() => _registrationDeadline = picked);
              },
            ),
          BaseDropdownFormField<_CancelDeadline>(
            labelText: "jobs_cancellation_deadline",
            initialValue: _cancelDeadline,
            items: [for (final e in _CancelDeadline.values) DropdownMenuItem(value: e, child: Text(e.label.i18n()))],
            onChanged: (value) => value == null ? null : setState(() => _cancelDeadline = value),
          ),
          if (_cancelDeadline == _CancelDeadline.date)
            _DateTimeField(
              label: "jobs_cancellation_deadline",
              value: _cancellationDeadline,
              onTap: () async {
                final picked = await _pickDateTime(_cancellationDeadline);
                if (picked != null) setState(() => _cancellationDeadline = picked);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRepeat() {
    final theme = Theme.of(context);
    return BaseContainer(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("jobs_repeat".i18n(), style: theme.textTheme.titleSmall),
          BaseDropdownFormField<_Repeat>(
            labelText: "jobs_repeat_mode",
            initialValue: _repeat,
            items: [for (final mode in _Repeat.values) DropdownMenuItem(value: mode, child: Text(mode.label.i18n()))],
            onChanged: (value) => value == null ? null : setState(() => _repeat = value),
          ),
          if (_repeat == _Repeat.days)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Wrap(
                spacing: 8.sp,
                children: [
                  for (var d = 1; d <= 7; d++)
                    FilterChip(
                      label: Text("weekday_${_dayNames[d - 1]}".i18n()),
                      selected: _repeatDays.contains(d),
                      onSelected: (on) => setState(() => on ? _repeatDays.add(d) : _repeatDays.remove(d)),
                    ),
                ],
              ),
            ),
          if (_repeat != _Repeat.none) ...[
            _DateTimeField(
              label: "jobs_repeat_until",
              value: _repeatUntil,
              dateOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _repeatUntil.isBefore(_jobDateTime) ? _jobDateTime : _repeatUntil,
                  firstDate: _jobDateTime,
                  lastDate: DateTime(_jobDateTime.year + 2, 12, 31),
                );
                if (picked != null) setState(() => _repeatUntil = picked);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
              child: Text(
                _repeat == _Repeat.weekly
                    ? "jobs_repeat_summary_weekly".i18n([
                        "weekday_${_dayNames[_jobDateTime.weekday - 1]}".i18n(),
                        "$_occurrenceCount",
                      ])
                    : "jobs_repeat_summary_days".i18n(["$_occurrenceCount"]),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLimits() {
    final theme = Theme.of(context);
    String? positive(String? text) {
      if (text == null || text.trim().isEmpty) return null;
      final value = int.tryParse(text.trim());
      return value == null || value < 1 ? "jobs_form_number_invalid".i18n() : null;
    }

    String? nonNegative(String? text) {
      if (text == null || text.trim().isEmpty) return null;
      final value = int.tryParse(text.trim());
      return value == null || value < 0 ? "jobs_form_number_invalid".i18n() : null;
    }

    return BaseContainer(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("jobs_limits".i18n(), style: theme.textTheme.titleSmall),
          BaseTextFormField(
            controller: _maxParticipants,
            labelText: "jobs_max_participants".i18n(),
            hintText: "jobs_unlimited",
            keyBoardType: TextInputType.number,
            validator: positive,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
            title: Text("jobs_waitlist_enabled".i18n()),
            value: _waitlist,
            onChanged: (value) => setState(() => _waitlist = value),
          ),
          Row(
            children: [
              Expanded(
                child: BaseTextFormField(
                  controller: _minAge,
                  labelText: "jobs_min_age".i18n(),
                  keyBoardType: TextInputType.number,
                  validator: nonNegative,
                ),
              ),
              Expanded(
                child: BaseTextFormField(
                  controller: _maxAge,
                  labelText: "jobs_max_age".i18n(),
                  keyBoardType: TextInputType.number,
                  validator: nonNegative,
                ),
              ),
            ],
          ),
          BaseDropdownFormField<Gender?>(
            labelText: "jobs_gender",
            initialValue: _gender,
            items: [
              DropdownMenuItem<Gender?>(value: null, child: Text("jobs_gender_any".i18n())),
              ...Gender.values.map((e) => DropdownMenuItem<Gender?>(value: e, child: Text(e.label.i18n()))),
            ],
            onChanged: (value) => setState(() => _gender = value),
          ),
        ],
      ),
    );
  }
}

/// When people can start registering. "Closed" keeps everyone out until the job is opened again.
enum _RegStart {
  open("jobs_reg_start_open"),
  date("jobs_reg_select_date"),
  closed("jobs_reg_start_closed");

  final String label;

  const _RegStart(this.label);
}

enum _RegDeadline {
  startDate("jobs_reg_start_date"),
  none("jobs_reg_none"),
  date("jobs_reg_select_date");

  final String label;

  const _RegDeadline(this.label);
}

enum _CancelDeadline {
  notAllowed("jobs_cancel_not_allowed"),
  registrationDeadline("jobs_cancel_registration_deadline"),
  startDate("jobs_reg_start_date"),
  endDate("jobs_cancel_end_date"),
  none("jobs_no_deadline"),
  date("jobs_reg_select_date");

  final String label;

  const _CancelDeadline(this.label);
}

enum _Repeat {
  none("jobs_repeat_none"),
  weekly("jobs_repeat_weekly"),
  days("jobs_repeat_days");

  final String label;

  const _Repeat(this.label);
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.label, required this.value, required this.onTap, this.dateOnly = false});

  final String label;
  final DateTime value;
  final bool dateOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BaseLabeledField(
      labelText: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.sp),
        child: InputDecorator(
          decoration: baseInputDecoration(Theme.of(context), suffixIcon: const Icon(Icons.calendar_month)),
          child: Text(dateOnly ? Utils.dateToString(value) : Utils.dateToStringWithTime(value)),
        ),
      ),
    );
  }
}
