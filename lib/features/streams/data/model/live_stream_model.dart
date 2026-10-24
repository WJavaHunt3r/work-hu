/// A stream that is on the air. [hlsUrl] and [iframeUrl] belong to the live input, so they keep working when the
/// encoder drops and reconnects; [language] is a short code such as "hu" or "en" (empty when the admin set none).
class LiveStreamModel {
  const LiveStreamModel({
    required this.uid,
    required this.title,
    required this.language,
    required this.hlsUrl,
    required this.iframeUrl,
  });

  final String uid;
  final String title;
  final String language;
  final String hlsUrl;
  final String iframeUrl;

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) => LiveStreamModel(
    uid: json['uid'] as String? ?? '',
    title: json['title'] as String? ?? '',
    language: json['language'] as String? ?? '',
    hlsUrl: json['hlsUrl'] as String? ?? '',
    iframeUrl: json['iframeUrl'] as String? ?? '',
  );
}
