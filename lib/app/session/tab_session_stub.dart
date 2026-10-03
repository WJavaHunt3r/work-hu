// Native apps keep running while the payment page is open, so there is no tab session to restore.
bool isTabSessionActive() => false;

void markTabSessionActive() {}

void clearTabSession() {}
