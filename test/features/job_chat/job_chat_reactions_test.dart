import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/features/job_chat/data/model/job_chat_models.dart';
import 'package:work_hu/features/job_chat/providers/job_chat_provider.dart';

JobChatMessageModel _message(num id, {int likes = 0, int dislikes = 0, JobChatReaction? mine}) => JobChatMessageModel(
  id: id,
  userId: 1,
  userName: 'Éva',
  text: 'Szia',
  createDateTime: null,
  likes: likes,
  dislikes: dislikes,
  myReaction: mine,
);

void main() {
  test('reads the reactions of a message and of the poll, and older backends without them', () {
    final chat = JobChatModel.fromJson({
      'messages': [
        {'id': 1, 'userId': 2, 'userName': 'Béla', 'text': 'hi', 'likes': 3, 'dislikes': 1, 'myReaction': 'DISLIKE'},
        {'id': 2, 'userId': 2, 'userName': 'Béla', 'text': 'old backend'},
      ],
      'muted': false,
      'archived': false,
      'reactionChanges': [
        {'messageId': 1, 'likes': 4, 'dislikes': 0, 'myReaction': null},
      ],
      'reactionsNext': '2026-10-30T12:00:00',
    });
    expect(chat.messages[0].likes, 3);
    expect(chat.messages[0].dislikes, 1);
    expect(chat.messages[0].myReaction, JobChatReaction.dislike);
    expect(chat.messages[1].likes, 0);
    expect(chat.messages[1].myReaction, isNull);
    expect(chat.reactionChanges.single.likes, 4);
    expect(chat.reactionsNext, '2026-10-30T12:00:00');

    final old = JobChatModel.fromJson({'messages': [], 'muted': false, 'archived': false});
    expect(old.reactionChanges, isEmpty);
    expect(old.reactionsNext, isNull);
  });

  test('a reaction is counted at once: set, replaced and taken back', () {
    const none = JobChatReactionsModel(messageId: 1, likes: 2, dislikes: 1);
    final liked = JobChatNotifier.optimistic(none, JobChatReaction.like);
    expect([liked.likes, liked.dislikes, liked.myReaction], [3, 1, JobChatReaction.like]);

    final disliked = JobChatNotifier.optimistic(liked, JobChatReaction.dislike);
    expect([disliked.likes, disliked.dislikes, disliked.myReaction], [2, 2, JobChatReaction.dislike]);

    final back = JobChatNotifier.optimistic(disliked, null);
    expect([back.likes, back.dislikes, back.myReaction], [2, 1, null]);
  });

  test('changed reactions replace the counts of loaded messages only', () {
    final messages = [_message(1), _message(2, likes: 1, mine: JobChatReaction.like)];
    expect(
      identical(
        JobChatNotifier.applyReactions(messages, [const JobChatReactionsModel(messageId: 9, likes: 5)]),
        messages,
      ),
      isTrue,
    );

    final updated = JobChatNotifier.applyReactions(messages, [
      const JobChatReactionsModel(messageId: 2, likes: 0, dislikes: 2),
    ]);
    expect(updated[0], same(messages[0]));
    expect(updated[1].likes, 0);
    expect(updated[1].dislikes, 2);
    expect(updated[1].myReaction, isNull);
    expect(updated[1].text, 'Szia');
  });
}
