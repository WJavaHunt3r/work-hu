import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/providers/bible_provider.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart' show bibleChoiceProvider;

/// The active translation's text for [builder]; while it is being downloaded or when it can't be, a message instead.
class BibleTextView extends ConsumerWidget {
  const BibleTextView({super.key, required this.builder});

  final Widget Function(BuildContext context, Bible bible) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(bibleTranslationIdProvider);
    final text = ref.watch(bibleTextProvider(id));
    final bible = text.bible;
    if (bible != null) return builder(context, bible);

    final theme = Theme.of(context);
    final info = ref.watch(bibleTranslationsProvider).value?.where((t) => t.id == id).firstOrNull;
    final name = info?.shortName ?? id;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: text.failed
              ? [
                  Icon(Icons.cloud_off, size: 40.sp, color: theme.hintColor),
                  SizedBox(height: 12.sp),
                  Text("bible_download_failed".i18n([name]), textAlign: TextAlign.center),
                  SizedBox(height: 12.sp),
                  FilledButton.icon(
                    onPressed: () => ref.read(bibleTextProvider(id).notifier).retry(),
                    icon: const Icon(Icons.refresh),
                    label: Text("bible_retry".i18n()),
                  ),
                ]
              : [
                  const CircularProgressIndicator.adaptive(),
                  if (text.downloading) ...[
                    SizedBox(height: 16.sp),
                    Text(
                      info?.size == null
                          ? "bible_downloading".i18n([name])
                          : "bible_downloading_size".i18n([name, formatMegabytes(info!.size!)]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
        ),
      ),
    );
  }
}

/// "1.4 MB"
String formatMegabytes(int bytes) => "${(bytes / 1000000).toStringAsFixed(1)} MB";

/// The app bar button for parallel reading: picks the translation shown side by side with the active one, or
/// switches it off. Shows the second translation's short name while it is on.
class BibleParallelButton extends ConsumerWidget {
  const BibleParallelButton({super.key});

  /// The menu value that switches parallel reading off (a translation id is never empty).
  static const off = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(bibleTranslationIdProvider);
    final secondId = ref.watch(bibleParallelIdProvider);
    final translations = ref.watch(bibleTranslationsProvider).value ?? const <BibleTranslationInfo>[];
    final downloaded = ref.watch(bibleDownloadedProvider).value ?? const <String>{};
    final second = translations.where((t) => t.id == secondId).firstOrNull;
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: "bible_parallel".i18n(),
      initialValue: secondId ?? off,
      onSelected: (picked) => ref.read(bibleParallelChoiceProvider.notifier).select(picked == off ? null : picked),
      itemBuilder: (context) => [
        PopupMenuItem(enabled: false, child: Text("bible_parallel".i18n(), style: theme.textTheme.titleSmall)),
        PopupMenuItem(value: off, child: Text("bible_parallel_off".i18n())),
        const PopupMenuDivider(),
        for (final t in translations.where((t) => t.id != id))
          PopupMenuItem(
            value: t.id,
            child: Row(
              children: [
                Expanded(child: Text(t.fullName)),
                SizedBox(width: 8.sp),
                if (downloaded.contains(t.id))
                  Icon(Icons.download_done, size: 18.sp, color: theme.hintColor)
                else if (t.size != null)
                  Text(formatMegabytes(t.size!), style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.vertical_split_outlined, color: second == null ? null : theme.colorScheme.primary),
            if (second != null) ...[
              SizedBox(width: 4.sp),
              Text(
                second.shortName,
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The app bar button that shows the translation and switches it. Translations not yet on the device show their
/// download size.
class BibleTranslationButton extends ConsumerWidget {
  const BibleTranslationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(bibleTranslationIdProvider);
    final translations = ref.watch(bibleTranslationsProvider).value ?? const <BibleTranslationInfo>[];
    final downloaded = ref.watch(bibleDownloadedProvider).value ?? const <String>{};
    final current = translations.where((t) => t.id == id).firstOrNull;
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: "reading_plan_translation_pick".i18n(),
      initialValue: id,
      onSelected: (picked) => ref.read(bibleChoiceProvider.notifier).select(picked),
      itemBuilder: (context) => [
        for (final t in translations)
          PopupMenuItem(
            value: t.id,
            child: Row(
              children: [
                Expanded(child: Text(t.fullName)),
                SizedBox(width: 8.sp),
                if (downloaded.contains(t.id))
                  Icon(Icons.download_done, size: 18.sp, color: theme.hintColor)
                else if (t.size != null)
                  Text(formatMegabytes(t.size!), style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.translate),
            SizedBox(width: 4.sp),
            Text(current?.shortName ?? id, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
