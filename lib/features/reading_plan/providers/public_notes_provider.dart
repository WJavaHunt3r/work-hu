import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/reading_plan/data/api/public_note_api.dart';
import 'package:work_hu/features/reading_plan/data/model/public_note.dart';

final publicNoteApiProvider = Provider<PublicNoteApi>((ref) => PublicNoteApi());

/// Who may see public notes: church members, and managers (READING_PLAN_MANAGE) who moderate them.
final publicNotesAccessProvider = Provider<({bool read, bool manage})>((ref) {
  final user = ref.watch(userDataProvider).user;
  final manage = user?.hasPermission(Permission.READING_PLAN_MANAGE) ?? false;
  return (read: (user?.hasChurch() ?? false) || manage, manage: manage);
});

/// The visible public notes per item of a plan, for the psalm grid. Nothing is asked without access.
final publicNoteCountsProvider = FutureProvider.autoDispose.family<Map<int, int>, num>((ref, planId) async {
  if (!ref.watch(publicNotesAccessProvider).read) return const {};
  final json = await guardApi(() => ref.read(publicNoteApiProvider).getCounts(planId));
  return {for (final e in json.entries) int.parse(e.key): (e.value as num).toInt()};
});

/// The public notes of one item. Changes go to the server and the list is asked for again; a refusal (e.g. the plan
/// closed) is shown with [showApiError] and the list stays as it was.
final publicNotesProvider = StateNotifierProvider.autoDispose
    .family<PublicNotesNotifier, AsyncValue<List<PublicNote>>, ({num planId, int item})>((ref, key) {
      // Without access nothing is asked for: an empty list
      final read = ref.watch(publicNotesAccessProvider).read;
      return PublicNotesNotifier(ref.read(publicNoteApiProvider), key.planId, key.item, () {
        ref.invalidate(publicNoteCountsProvider(key.planId));
      }, enabled: read);
    });

class PublicNotesNotifier extends StateNotifier<AsyncValue<List<PublicNote>>> {
  PublicNotesNotifier(this._api, this.planId, this.item, this._changed, {bool enabled = true})
    : super(enabled ? const AsyncValue.loading() : const AsyncValue.data([])) {
    if (enabled) load();
  }

  final PublicNoteApi _api;
  final num planId;
  final int item;
  final void Function() _changed;

  Future<void> load() async {
    try {
      final list = await guardApi(() => _api.getForItem(planId, item));
      if (mounted) state = AsyncValue.data([for (final n in list) PublicNote.fromJson(n as Map<String, dynamic>)]);
    } catch (e, st) {
      if (mounted && !state.hasValue) state = AsyncValue.error(e, st);
    }
  }

  /// Runs a change and reloads; false when the server refused (its message is shown).
  Future<bool> _change(Future<void> Function() call) async {
    try {
      await guardApi(call);
    } on ApiException catch (e) {
      showApiError(e.message);
      return false;
    } catch (_) {
      showApiError("api_unknown_error".i18n());
      return false;
    }
    await load();
    _changed();
    return true;
  }

  Future<bool> create({
    required int verseStart,
    required int verseEnd,
    required String translation,
    required String numbering,
    required String text,
  }) => _change(
    () => _api.create(planId, {
      'item': item,
      'verseStart': verseStart,
      'verseEnd': verseEnd,
      'translation': translation,
      'numbering': numbering,
      'text': text,
    }),
  );

  Future<bool> edit(PublicNote note, String text) => _change(() => _api.update(planId, note.id, text));

  Future<bool> delete(PublicNote note) => _change(() => _api.delete(planId, note.id));

  Future<bool> report(PublicNote note, String? reason) => _change(() => _api.report(planId, note.id, reason));

  Future<bool> setHidden(PublicNote note, bool hidden) => _change(() => _api.setHidden(planId, note.id, hidden));
}

/// Managers: the reported notes of a plan.
final reportedNotesProvider = FutureProvider.autoDispose.family<List<ReportedNote>, num>((ref, planId) async {
  final list = await guardApi(() => ref.read(publicNoteApiProvider).getReported(planId));
  return [for (final r in list) ReportedNote.fromJson(r as Map<String, dynamic>)];
});
