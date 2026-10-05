/// Holds the location a user was heading to (deep link or push notification tap) while they are not signed in.
/// The router stores it when it sends an anonymous user to `/login` and consumes it once they are signed in.
class DeepLink {
  DeepLink._();

  static String? _pending;

  static void remember(String location) {
    if (location.isEmpty || location == '/' || location.startsWith('/login')) return;
    _pending = location;
  }

  /// Returns the remembered location once and forgets it.
  static String? consume() {
    final location = _pending;
    _pending = null;
    return location;
  }

  static bool get hasPending => _pending != null;

  /// Maps the data of a push message to an in-app location.
  ///
  /// The backend's payload carries `type` plus ids (`jobId`), which are mapped to a screen here. An explicit `route`
  /// (an in-app path such as `/jobs/12`) wins if a message ever includes one.
  static String? fromPushData(Map<String, dynamic> data) {
    final route = data['route'] ?? data['deepLink'] ?? data['link'];
    if (route is String && route.trim().isNotEmpty) return _normalize(route.trim());

    final type = (data['type'] as String?)?.toUpperCase();
    final jobId = data['jobId'];
    switch (type) {
      case 'JOB_NEW':
      case 'JOB_REGISTERED_BY_OTHER':
      case 'JOB_CANCELLED':
      case 'JOB_NOT_CLOSED':
        return jobId == null ? '/jobs' : '/jobs/$jobId';
      case 'JOB_CHAT_MESSAGE':
        return jobId == null ? '/jobs' : '/jobs/$jobId/chat';
      case 'TRANSACTION_CREATED':
        return '/status';
      // WEEKLY / GENERAL carry no target: tapping just opens the app.
    }
    return null;
  }

  /// Accepts an absolute app URL (`https://dukapp.bcc-ktk.org/jobs/12`, `dukapp://jobs/12`) or a path.
  static String? _normalize(String route) {
    final uri = Uri.tryParse(route);
    if (uri == null) return null;
    if (uri.hasScheme) {
      final path = uri.scheme.startsWith('http') ? uri.path : '/${uri.host}${uri.path}';
      return uri.hasQuery ? '$path?${uri.query}' : path;
    }
    return route.startsWith('/') ? route : '/$route';
  }
}
