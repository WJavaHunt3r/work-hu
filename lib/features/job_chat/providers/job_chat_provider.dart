import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/job_chat/data/api/job_chat_api.dart';
import 'package:work_hu/features/job_chat/data/model/job_chat_models.dart';
import 'package:work_hu/features/job_chat/data/repository/job_chat_repository.dart';

final jobChatRepoProvider = Provider<JobChatRepository>((ref) => JobChatRepository(JobChatApi()));

final jobChatProvider = StateNotifierProvider.autoDispose.family<JobChatNotifier, JobChatState, num>(
  (ref, jobId) => JobChatNotifier(ref.read(jobChatRepoProvider), jobId),
);

class JobChatState {
  const JobChatState({
    this.messages = const [],
    this.muted = false,
    this.archived = false,
    this.loading = true,
    this.hasOlder = false,
    this.sending = false,
    this.error,
  });

  /// Oldest first.
  final List<JobChatMessageModel> messages;
  final bool muted;
  final bool archived;
  final bool loading;
  final bool hasOlder;
  final bool sending;

  /// The backend's reason when the chat can't be opened (e.g. the user doesn't take part in the job).
  final String? error;

  JobChatState copyWith({
    List<JobChatMessageModel>? messages,
    bool? muted,
    bool? archived,
    bool? loading,
    bool? hasOlder,
    bool? sending,
    String? error,
    bool clearError = false,
  }) => JobChatState(
    messages: messages ?? this.messages,
    muted: muted ?? this.muted,
    archived: archived ?? this.archived,
    loading: loading ?? this.loading,
    hasOlder: hasOlder ?? this.hasOlder,
    sending: sending ?? this.sending,
    error: clearError ? null : error ?? this.error,
  );
}

/// Loads the chat and polls for new messages while the page is open (pushes cover the time it is closed).
class JobChatNotifier extends StateNotifier<JobChatState> {
  JobChatNotifier(this._repository, this.jobId) : super(const JobChatState()) {
    load();
    _timer = Timer.periodic(_pollInterval, (_) => poll());
  }

  static const _pollInterval = Duration(seconds: 8);
  static const _pageSize = 50;

  final JobChatRepository _repository;
  final num jobId;
  Timer? _timer;
  bool _polling = false;

  /// The last answer's `reactionsNext`: the next poll asks for the reactions changed since then.
  String? _reactionsNext;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final chat = await _repository.getChat(jobId);
      if (!mounted) return;
      _reactionsNext = chat.reactionsNext;
      state = state.copyWith(
        messages: chat.messages,
        muted: chat.muted,
        archived: chat.archived,
        loading: false,
        hasOlder: chat.messages.length >= _pageSize,
        clearError: true,
      );
    } on ApiException catch (e) {
      if (mounted) state = state.copyWith(loading: false, error: e.message);
    } catch (_) {
      if (mounted) state = state.copyWith(loading: false, error: "api_unknown_error");
    }
  }

  Future<void> poll() async {
    if (_polling || state.loading || state.error != null) return;
    _polling = true;
    try {
      final last = state.messages.isEmpty ? null : state.messages.last.id;
      if (last == null) {
        await load();
        return;
      }
      final chat = await _repository.getChat(jobId, after: last, reactionsSince: _reactionsNext);
      if (!mounted) return;
      _reactionsNext = chat.reactionsNext ?? _reactionsNext;
      final merged = chat.messages.isEmpty ? state.messages : _merge(state.messages, chat.messages);
      final withReactions = applyReactions(merged, chat.reactionChanges);
      state = state.copyWith(
        messages: identical(withReactions, state.messages) ? null : withReactions,
        muted: chat.muted,
        archived: chat.archived,
      );
    } catch (_) {
      // A failed poll is retried by the next one.
    } finally {
      _polling = false;
    }
  }

  Future<void> loadOlder() async {
    if (state.messages.isEmpty) return;
    try {
      final chat = await _repository.getChat(jobId, before: state.messages.first.id);
      if (!mounted) return;
      state = state.copyWith(
        messages: _merge(chat.messages, state.messages),
        hasOlder: chat.messages.length >= _pageSize,
      );
    } catch (_) {}
  }

  /// Returns the backend's reason when sending failed (e.g. the chat was archived meanwhile), otherwise null.
  Future<String?> send(String text) async {
    state = state.copyWith(sending: true);
    try {
      final message = await _repository.send(jobId, text);
      if (mounted) state = state.copyWith(messages: _merge(state.messages, [message]), sending: false);
      return null;
    } on ApiException catch (e) {
      if (mounted) state = state.copyWith(sending: false);
      return e.message;
    } catch (_) {
      if (mounted) state = state.copyWith(sending: false);
      return "api_unknown_error";
    }
  }

  /// Tapping a reaction: the same one again takes it back, the other one replaces it. Shown at once and set back
  /// when the backend refuses; returns the backend's reason then (e.g. the chat was archived meanwhile).
  Future<String?> toggleReaction(JobChatMessageModel message, JobChatReaction reaction) async {
    final wanted = message.myReaction == reaction ? null : reaction;
    final before = JobChatReactionsModel(
      messageId: message.id,
      likes: message.likes,
      dislikes: message.dislikes,
      myReaction: message.myReaction,
    );
    state = state.copyWith(messages: applyReactions(state.messages, [optimistic(before, wanted)]));
    try {
      final result = await _repository.react(jobId, message.id, wanted);
      if (mounted) state = state.copyWith(messages: applyReactions(state.messages, [result]));
      return null;
    } on ApiException catch (e) {
      if (mounted) state = state.copyWith(messages: applyReactions(state.messages, [before]));
      return e.message;
    } catch (_) {
      if (mounted) state = state.copyWith(messages: applyReactions(state.messages, [before]));
      return "api_unknown_error";
    }
  }

  /// The counts after the user's reaction changes from [current]'s to [wanted] (null = none).
  static JobChatReactionsModel optimistic(JobChatReactionsModel current, JobChatReaction? wanted) {
    int count(JobChatReaction r, int n) => n - (current.myReaction == r ? 1 : 0) + (wanted == r ? 1 : 0);
    return JobChatReactionsModel(
      messageId: current.messageId,
      likes: count(JobChatReaction.like, current.likes),
      dislikes: count(JobChatReaction.dislike, current.dislikes),
      myReaction: wanted,
    );
  }

  /// [messages] with the [changes] applied; the same list when none of them is loaded.
  static List<JobChatMessageModel> applyReactions(
    List<JobChatMessageModel> messages,
    List<JobChatReactionsModel> changes,
  ) {
    if (changes.isEmpty) return messages;
    final byId = {for (final c in changes) c.messageId: c};
    if (!messages.any((m) => byId.containsKey(m.id))) return messages;
    return [for (final m in messages) byId.containsKey(m.id) ? m.withReactions(byId[m.id]!) : m];
  }

  Future<void> setMuted(bool muted) async {
    final before = state.muted;
    state = state.copyWith(muted: muted);
    try {
      await _repository.setMuted(jobId, muted);
    } catch (_) {
      if (mounted) state = state.copyWith(muted: before);
    }
  }

  /// Both lists oldest first; messages already present (by id) aren't added twice.
  static List<JobChatMessageModel> _merge(List<JobChatMessageModel> a, List<JobChatMessageModel> b) {
    final byId = {
      for (final m in [...a, ...b]) m.id: m,
    };
    return byId.values.toList()..sort((x, y) => x.id.compareTo(y.id));
  }
}
