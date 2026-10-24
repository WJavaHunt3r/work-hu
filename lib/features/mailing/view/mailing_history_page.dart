import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/mailing/data/model/mailing_models.dart';
import 'package:work_hu/features/mailing/view/mailing_page.dart';

final _mailingHistoryProvider = FutureProvider.autoDispose<List<MailingModel>>(
  (ref) => ref.read(mailingRepoProvider).getHistory(),
);

/// The mailings sent so far, newest first, with how many addresses each reached.
class MailingHistoryPage extends ConsumerWidget {
  const MailingHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(_mailingHistoryProvider);
    final theme = Theme.of(context);
    final format = DateFormat("yyyy.MM.dd HH:mm");
    return Scaffold(
      appBar: AppBar(
        title: Text("mailing_history".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(child: Text(error is ApiException ? error.message : "api_unknown_error".i18n())),
        data: (list) => list.isEmpty
            ? Center(child: Text("mailing_history_empty".i18n()))
            : RefreshIndicator.adaptive(
                onRefresh: () async => ref.refresh(_mailingHistoryProvider.future),
                child: ListView.separated(
                  padding: EdgeInsets.all(16.sp),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final m = list[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        [
                          if (m.sentDateTime != null) format.format(m.sentDateTime!),
                          if (m.sentByName != null) m.sentByName!,
                        ].join(" · "),
                      ),
                      trailing: Text(
                        m.failedCount == 0
                            ? "mailing_history_reached".i18n(["${m.recipientCount}"])
                            : "mailing_history_failed".i18n([
                                "${m.recipientCount - m.failedCount}",
                                "${m.failedCount}",
                              ]),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: m.failedCount == 0 ? null : theme.colorScheme.error,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
