package com.ktk.dukapp

import com.ryanheise.audioservice.AudioServiceFragmentActivity

// The activity of just_audio_background (audio-only live streams keep playing with the screen off); the Fragment
// variant because local_auth (biometric unlock) needs a FragmentActivity
class MainActivity: AudioServiceFragmentActivity() {
}
