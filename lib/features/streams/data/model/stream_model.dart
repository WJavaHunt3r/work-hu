/// A Cloudflare live input: the address and secret key to broadcast to it. [uid] identifies it for deleting.
class StreamModel {
  const StreamModel({
    required this.uid,
    required this.title,
    required this.rtmpsUrl,
    required this.streamKey,
    this.created,
    this.language = '',
  });

  final String uid;
  final String title;
  final String rtmpsUrl;

  /// The secret: whoever has it can broadcast to the stream.
  final String streamKey;
  final DateTime? created;

  /// Language of the audio ("hu", "en", ...), empty when not set.
  final String language;

  factory StreamModel.fromJson(Map<String, dynamic> json) => StreamModel(
    uid: json['uid'] as String? ?? '',
    title: json['title'] as String? ?? '',
    rtmpsUrl: json['rtmpsUrl'] as String? ?? '',
    streamKey: json['streamKey'] as String? ?? '',
    created: DateTime.tryParse(json['created'] as String? ?? ''),
    language: json['language'] as String? ?? '',
  );
}
