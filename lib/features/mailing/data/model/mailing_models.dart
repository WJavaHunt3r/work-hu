/// A mailing that was sent to the members.
class MailingModel {
  const MailingModel({
    required this.id,
    required this.subject,
    required this.sentByName,
    required this.sentDateTime,
    required this.recipientCount,
    required this.failedCount,
  });

  final num id;
  final String subject;
  final String? sentByName;
  final DateTime? sentDateTime;
  final int recipientCount;
  final int failedCount;

  factory MailingModel.fromJson(Map<String, dynamic> json) => MailingModel(
    id: json['id'] as num,
    subject: json['subject'] as String? ?? '',
    sentByName: json['sentByName'] as String?,
    sentDateTime: DateTime.tryParse(json['sentDateTime'] as String? ?? ''),
    recipientCount: (json['recipientCount'] as num?)?.toInt() ?? 0,
    failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
  );
}

/// How many members a mailing reaches, and how many members have no usable e-mail address.
class MailingRecipientsModel {
  const MailingRecipientsModel({
    required this.count,
    required this.members,
    required this.withoutEmail,
    required this.withoutEmailNames,
  });

  /// Members with a usable address: the ones a mailing reaches.
  final int count;

  /// All members, with or without an address.
  final int members;
  final int withoutEmail;

  /// The first few members that have no usable address, so they can be fixed.
  final List<String> withoutEmailNames;

  factory MailingRecipientsModel.fromJson(Map<String, dynamic> json) => MailingRecipientsModel(
    count: (json['count'] as num?)?.toInt() ?? 0,
    members: (json['members'] as num?)?.toInt() ?? 0,
    withoutEmail: (json['withoutEmail'] as num?)?.toInt() ?? 0,
    withoutEmailNames: (json['withoutEmailNames'] as List? ?? []).map((e) => e.toString()).toList(),
  );
}
