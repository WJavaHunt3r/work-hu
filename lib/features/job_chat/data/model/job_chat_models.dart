/// One message in the chat of a job.
class JobChatMessageModel {
  const JobChatMessageModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createDateTime,
  });

  final num id;
  final num userId;
  final String userName;
  final String text;
  final DateTime? createDateTime;

  factory JobChatMessageModel.fromJson(Map<String, dynamic> json) => JobChatMessageModel(
    id: json['id'] as num,
    userId: json['userId'] as num,
    userName: json['userName'] as String? ?? '',
    text: json['text'] as String? ?? '',
    createDateTime: json['createDateTime'] == null ? null : DateTime.tryParse(json['createDateTime'] as String),
  );
}

/// What `GET /job/{id}/chat` returns: messages oldest first, whether the user muted the chat, and whether it is
/// archived (read only, the job is closed).
class JobChatModel {
  const JobChatModel({required this.messages, required this.muted, required this.archived});

  final List<JobChatMessageModel> messages;
  final bool muted;
  final bool archived;

  factory JobChatModel.fromJson(Map<String, dynamic> json) => JobChatModel(
    messages: (json['messages'] as List? ?? [])
        .map((e) => JobChatMessageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    muted: json['muted'] as bool? ?? false,
    archived: json['archived'] as bool? ?? false,
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
