import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

/// True in the iOS app: Cupertino widgets are used there. Android and the web (also in an iPhone browser) keep Material.
bool useCupertino(BuildContext context) => !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS;

/// Drop-in for [AlertDialog]: a Material dialog everywhere except the iOS app, where it is a [CupertinoAlertDialog].
///
/// Material buttons given as [actions] (TextButton, FilledButton, OutlinedButton) become [CupertinoDialogAction]s on
/// iOS, the filled one as the bold default action, so the call sites don't change. The parameters that only make
/// sense for the Material dialog (width constraints, alignment, colors) are ignored on iOS.
class AdaptiveAlertDialog extends StatelessWidget {
  const AdaptiveAlertDialog({
    super.key,
    this.title,
    this.content,
    this.icon,
    this.actions,
    this.actionsAlignment,
    this.constraints,
    this.alignment,
    this.backgroundColor,
    this.titleTextStyle,
  });

  final Widget? title;
  final Widget? content;
  final Widget? icon;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    if (!useCupertino(context)) {
      return AlertDialog(
        title: title,
        content: content,
        icon: icon,
        actions: actions,
        actionsAlignment: actionsAlignment,
        constraints: constraints,
        alignment: alignment,
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
      );
    }
    return CupertinoAlertDialog(
      title: icon == null
          ? title
          : Column(mainAxisSize: MainAxisSize.min, children: [icon!, if (title != null) title!]),
      // Text fields in the content need a Material ancestor for their selection handles and ink
      content: content == null ? null : Material(type: MaterialType.transparency, child: content),
      actions: [for (final action in actions ?? const <Widget>[]) _cupertinoAction(action)],
    );
  }

  static Widget _cupertinoAction(Widget action) {
    if (action is ButtonStyleButton) {
      return CupertinoDialogAction(
        onPressed: action.onPressed,
        isDefaultAction: action is FilledButton,
        child: action.child ?? const SizedBox.shrink(),
      );
    }
    return action;
  }
}

/// A date picker: the Material one, or a wheel in a bottom popup on iOS. Returns null when cancelled.
Future<DateTime?> pickDate({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  if (!useCupertino(context)) {
    return showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);
  }
  final initial = initialDate.isBefore(firstDate)
      ? firstDate
      : initialDate.isAfter(lastDate)
      ? lastDate
      : initialDate;
  return _cupertinoPicker(
    context,
    mode: CupertinoDatePickerMode.date,
    initial: initial,
    minimum: firstDate,
    maximum: lastDate,
  );
}

/// A time picker: the Material one, or a wheel in a bottom popup on iOS. Returns null when cancelled.
Future<TimeOfDay?> pickTime({required BuildContext context, required TimeOfDay initialTime}) async {
  if (!useCupertino(context)) {
    return showTimePicker(context: context, initialTime: initialTime);
  }
  final now = DateTime.now();
  final picked = await _cupertinoPicker(
    context,
    mode: CupertinoDatePickerMode.time,
    initial: DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute),
  );
  return picked == null ? null : TimeOfDay(hour: picked.hour, minute: picked.minute);
}

Future<DateTime?> _cupertinoPicker(
  BuildContext context, {
  required CupertinoDatePickerMode mode,
  required DateTime initial,
  DateTime? minimum,
  DateTime? maximum,
}) async {
  var selected = initial;
  final confirmed = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (popupContext) => Container(
      height: 300 + MediaQuery.paddingOf(popupContext).bottom,
      color: CupertinoColors.systemBackground.resolveFrom(popupContext),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.of(popupContext).pop(false),
                child: Text("base_cancel".i18n()),
              ),
              CupertinoButton(
                onPressed: () => Navigator.of(popupContext).pop(true),
                child: Text("base_ok".i18n(), style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: mode,
              initialDateTime: initial,
              minimumDate: minimum,
              maximumDate: maximum,
              use24hFormat: true,
              onDateTimeChanged: (value) => selected = value,
            ),
          ),
        ],
      ),
    ),
  );
  return confirmed == true ? selected : null;
}

/// A choice of one among a few labeled options: Material's [SegmentedButton], or iOS's sliding segmented control.
/// With [allowEmpty] nothing can be selected (iOS: tapping the selected segment leaves the value as it is).
class AdaptiveSegmented<T extends Object> extends StatelessWidget {
  const AdaptiveSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.allowEmpty = false,
  });

  /// Value to label, in display order.
  final Map<T, String> options;
  final T? selected;
  final void Function(T? value) onChanged;
  final bool allowEmpty;

  @override
  Widget build(BuildContext context) {
    if (!useCupertino(context)) {
      return SegmentedButton<T>(
        emptySelectionAllowed: allowEmpty,
        showSelectedIcon: false,
        segments: [for (final e in options.entries) ButtonSegment<T>(value: e.key, label: Text(e.value))],
        selected: {if (selected != null) selected!},
        onSelectionChanged: (selection) => onChanged(selection.isEmpty ? null : selection.first),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<T>(
        groupValue: selected,
        children: {
          for (final e in options.entries)
            e.key: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(e.value)),
        },
        onValueChanged: (value) => onChanged(value),
      ),
    );
  }
}
