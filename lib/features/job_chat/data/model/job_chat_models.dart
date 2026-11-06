/// A reaction to a chat message.
enum JobChatReaction {
  like,
  dislike;

  /// The backend's name: LIKE or DISLIKE.
  String get apiName => name.toUpperCase();

  static JobChatReaction? fromApi(Object? value) => switch (value) {
    'LIKE' => JobChatReaction.like,
    'DISLIKE' => JobChatReaction.dislike,
    _ => null,
  };
}

/// One message in the chat of a job, with its likes and dislikes and the user's own reaction ([myReaction]).
class JobChatMessageModel {
  const JobChatMessageModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createDateTime,
    this.likes = 0,
    this.dislikes = 0,
    this.myReaction,
  });

  final num id;
  final num userId;
  final String userName;
  final String text;
  final DateTime? createDateTime;
  final int likes;
  final int dislikes;
  final JobChatReaction? myReaction;

  factory JobChatMessageModel.fromJson(Map<String, dynamic> json) => JobChatMessageModel(
    id: json['id'] as num,
    userId: json['userId'] as num,
    userName: json['userName'] as String? ?? '',
    text: json['text'] as String? ?? '',
    createDateTime: json['createDateTime'] == null ? null : DateTime.tryParse(json['createDateTime'] as String),
    likes: (json['likes'] as num?)?.toInt() ?? 0,
    dislikes: (json['dislikes'] as num?)?.toInt() ?? 0,
    myReaction: JobChatReaction.fromApi(json['myReaction']),
  );

  JobChatMessageModel withReactions(JobChatReactionsModel r) => JobChatMessageModel(
    id: id,
    userId: userId,
    userName: userName,
    text: text,
    createDateTime: createDateTime,
    likes: r.likes,
    dislikes: r.dislikes,
    myReaction: r.myReaction,
  );
}

/// The reactions of one message, as `PUT|DELETE /job/{id}/chat/messages/{messageId}/reaction` and the poll's
/// `reactionChanges` return them.
class JobChatReactionsModel {
  const JobChatReactionsModel({required this.messageId, this.likes = 0, this.dislikes = 0, this.myReaction});

  final num messageId;
  final int likes;
  final int dislikes;
  final JobChatReaction? myReaction;

  factory JobChatReactionsModel.fromJson(Map<String, dynamic> json) => JobChatReactionsModel(
    messageId: json['messageId'] as num,
    likes: (json['likes'] as num?)?.toInt() ?? 0,
    dislikes: (json['dislikes'] as num?)?.toInt() ?? 0,
    myReaction: JobChatReaction.fromApi(json['myReaction']),
  );
}

/// What `GET /job/{id}/chat` returns: messages oldest first, whether the user muted the chat, and whether it is
/// archived (read only, the job is closed). [reactionChanges]: the reactions of messages changed since the request's
/// `reactionsSince`; [reactionsNext] is what to send as `reactionsSince` on the next poll (null from older backends).
class JobChatModel {
  const JobChatModel({
    required this.messages,
    required this.muted,
    required this.archived,
    this.reactionChanges = const [],
    this.reactionsNext,
  });

  final List<JobChatMessageModel> messages;
  final bool muted;
  final bool archived;
  final List<JobChatReactionsModel> reactionChanges;
  final String? reactionsNext;

  factory JobChatModel.fromJson(Map<String, dynamic> json) => JobChatModel(
    messages: (json['messages'] as List? ?? [])
        .map((e) => JobChatMessageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    muted: json['muted'] as bool? ?? false,
    archived: json['archived'] as bool? ?? false,
    reactionChanges: (json['reactionChanges'] as List? ?? [])
        .map((e) => JobChatReactionsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    reactionsNext: json['reactionsNext'] as String?,
  );
}

/// Someone in the chat. [role]: REGISTERED, RESPONSIBLE, CREATOR, or MEMBER (added to the chat only, [removable]).
class JobChatPersonModel {
  const JobChatPersonModel({required this.userId, required this.userName, required this.role, required this.removable});

  final num userId;
  final String userName;
  final String role;
  final bool removable;

  factory JobChatPersonModel.fromJson(Map<String, dynamic> json) => JobChatPersonModel(
    userId: json['userId'] as num,
    userName: json['userName'] as String? ?? '',
    role: json['role'] as String? ?? 'REGISTERED',
    removable: json['removable'] as bool? ?? false,
  );
}

/// Everyone in the chat, and whether the current user may add and remove chat-only members.
class JobChatPeopleModel {
  const JobChatPeopleModel({required this.participants, required this.canManage});

  final List<JobChatPersonModel> participants;
  final bool canManage;

  factory JobChatPeopleModel.fromJson(Map<String, dynamic> json) => JobChatPeopleModel(
    participants: (json['participants'] as List? ?? [])
        .map((e) => JobChatPersonModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    canManage: json['canManage'] as bool? ?? false,
  );
}
