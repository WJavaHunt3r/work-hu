import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/widgets/base_form_field.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/season/provider/seasons_list_provider.dart';
import 'package:work_hu/features/utils.dart';

/// Admin → Rounds → one round: the form to create a round ([id] null) or edit it. Rounds can't be deleted, because
/// their points and statistics hang on them; one that is no longer wanted is switched to inactive instead.
class RoundEditPage extends ConsumerStatefulWidget {
  const RoundEditPage({super.key, this.id});

  final num? id;

  @override
  ConsumerState<RoundEditPage> createState() => _RoundEditPageState();
}

class _RoundEditPageState extends ConsumerState<RoundEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _goal = TextEditingController();
  final _localGoal = TextEditingController();
  final _samvirkGoal = TextEditingController();
  final _samvirkChurchGoal = TextEditingController();
  final _churchStatus = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _active = true;
  num? _seasonId;
  DateTime? _start;
  DateTime? _end;
  DateTime? _freeze;

  bool get _isNew => widget.id == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_number, _goal, _localGoal, _samvirkGoal, _samvirkChurchGoal, _churchStatus]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    if (_isNew) {
      setState(() => _loading = false);
      return;
    }
    try {
      final round = await ref.read(roundRepoProvider).getRound(widget.id);
      if (!mounted) return;
      _fill(round);
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      showApiError("api_unknown_error".i18n());
      context.pop();
    }
  }

  void _fill(RoundModel round) {
    _seasonId = round.season.id;
    _number.text = round.roundNumber.toString();
    _goal.text = round.myShareGoal.toString();
    _localGoal.text = round.localMyShareGoal.toString();
    _samvirkGoal.text = round.samvirkGoal.toString();
    _samvirkChurchGoal.text = round.samvirkChurchGoal.toString();
    _churchStatus.text = round.samvirkChurchStatus?.toString() ?? '';
    _start = round.startDateTime;
    _end = round.endDateTime;
    _freeze = round.freezeDateTime;
    _active = round.activeRound;
  }

  Future<void> _pick(DateTime? current, void Function(DateTime) set, {required int hour, required int minute}) async {
    final now = DateTime.now();
    final picked = await pickDate(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => set(DateTime(picked.year, picked.month, picked.day, hour, minute)));
  }

  num? _num(TextEditingController c) => num.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_seasonId == null || _start == null || _end == null) {
      showApiError("round_edit_missing".i18n());
      return;
    }
    final data = <String, dynamic>{
      "seasonId": _seasonId,
      "roundNumber": _num(_number)?.toInt(),
      "startDateTime": _start!.toIso8601String(),
      "endDateTime": _end!.toIso8601String(),
      "freezeDateTime": _freeze?.toIso8601String(),
      "myShareGoal": _num(_goal),
      "localMyShareGoal": _num(_localGoal),
      "samvirkGoal": _num(_samvirkGoal)?.toInt(),
      "samvirkChurchGoal": _num(_samvirkChurchGoal)?.toInt(),
      // Empty leaves the stored status as it is (0 for a new round)
      "samvirkChurchStatus": _num(_churchStatus),
      "activeRound": _active,
    };
    setState(() => _saving = true);
    try {
      final repo = ref.read(roundRepoProvider);
      _isNew ? await repo.postRound(data) : await repo.putRound(widget.id!, data);
      if (mounted) context.pop(true);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _requiredNumber(String? value) =>
      double.tryParse((value ?? "").trim().replaceAll(',', '.')) == null ? "round_edit_number_required".i18n() : null;

  @override
  Widget build(BuildContext context) {
    final seasons = ref.watch(seasonsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_isNew ? "round_edit_new" : "round_edit_title").i18n(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [TextButton(onPressed: _saving || _loading ? null : _save, child: Text("round_edit_save".i18n()))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              padding: EdgeInsets.all(8.sp),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    seasons.when(
                      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                      error: (_, _) => Text("api_unknown_error".i18n()),
                      data: (list) {
                        // A new round defaults to the latest season
                        _seasonId ??=
                            (list.toList()..sort((a, b) => b.seasonYear.compareTo(a.seasonYear))).firstOrNull?.id;
                        return BaseDropdownFormField<num>(
                          labelText: "rounds_maintenance_season",
                          initialValue: _seasonId,
                          items: [
                            for (final SeasonModel s in list)
                              DropdownMenuItem(value: s.id, child: Text("${s.seasonYear}")),
                          ],
                          onChanged: (value) => setState(() => _seasonId = value),
                        );
                      },
                    ),
                    BaseTextFormField(
                      labelText: "rounds_maintenance_roundNumber",
                      controller: _number,
                      keyBoardType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      fldControl: "3", // the widget only runs the validator with this

                      validator: (v) {
                        final n = int.tryParse(v ?? "");
                        return n == null || n < 1 || n > 12 ? "round_edit_number_range".i18n() : null;
                      },
                    ),
                    _DateField(
                      label: "rounds_maintenance_startDate",
                      value: _start,
                      onTap: () => _pick(_start, (d) => _start = d, hour: 0, minute: 0),
                    ),
                    _DateField(
                      label: "rounds_maintenance_endDate",
                      value: _end,
                      onTap: () => _pick(_end, (d) => _end = d, hour: 23, minute: 59),
                    ),
                    _DateField(
                      label: "round_edit_freeze",
                      value: _freeze,
                      onTap: () => _pick(_freeze, (d) => _freeze = d, hour: 23, minute: 59),
                    ),
                    BaseTextFormField(
                      labelText: "rounds_maintenance_goal",
                      controller: _goal,
                      keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                      fldControl: "3", // the widget only runs the validator with this

                      validator: _requiredNumber,
                    ),
                    BaseTextFormField(
                      labelText: "rounds_maintenance_localGoal",
                      controller: _localGoal,
                      keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    BaseTextFormField(
                      labelText: "round_edit_samvirk_goal",
                      controller: _samvirkGoal,
                      keyBoardType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    ),
                    BaseTextFormField(
                      labelText: "round_edit_samvirk_church_goal",
                      controller: _samvirkChurchGoal,
                      keyBoardType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    ),
                    BaseTextFormField(
                      labelText: "round_edit_church_status",
                      hintText: "round_edit_church_status_hint".i18n(),
                      controller: _churchStatus,
                      keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                      fldControl: "3", // the widget only runs the validator with this

                      validator: (v) {
                        final text = (v ?? "").trim();
                        if (text.isEmpty) return null; // empty: leave it as it is
                        final n = double.tryParse(text.replaceAll(',', '.'));
                        return n == null || n < 0 ? "round_edit_status_invalid".i18n() : null;
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                      title: Text("round_edit_active".i18n()),
                      subtitle: Text("round_edit_active_hint".i18n()),
                      value: _active,
                      onChanged: (value) => setState(() => _active = value),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// A read-only field that opens a date picker when tapped.
class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value, required this.onTap});

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BaseLabeledField(
      labelText: label.i18n(),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: baseInputDecoration(Theme.of(context), suffixIcon: const Icon(Icons.calendar_today_outlined)),
          child: Text(value == null ? " " : Utils.dateTimeToDateOnlyString(value)),
        ),
      ),
    );
  }
}
