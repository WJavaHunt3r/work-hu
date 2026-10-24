import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/features/streams/view/live_page.dart';

void main() {
  test('the apps promise playback with the screen off (the web build, which cannot, is not tested here)', () {
    // Tests run as a native (non-web) app: iPhone and Android both keep playing in the background
    expect(liveAudioOnlyHintKey(), 'live_audio_only_hint');
  });
}
