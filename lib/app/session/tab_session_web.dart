import 'package:web/web.dart' as web;

// sessionStorage lives as long as the browser tab: it survives navigating away (e.g. to the SumUp checkout)
// and back, and is cleared when the tab is closed.
const _key = 'dukapp_session_active';

bool isTabSessionActive() => web.window.sessionStorage.getItem(_key) == 'true';

void markTabSessionActive() => web.window.sessionStorage.setItem(_key, 'true');

void clearTabSession() => web.window.sessionStorage.removeItem(_key);
