package com.ktk.dukapp

import android.content.Context
import com.google.android.gms.cast.LaunchOptions
import com.google.android.gms.cast.framework.CastOptions
import com.google.android.gms.cast.framework.OptionsProvider
import com.google.android.gms.cast.framework.SessionProvider
import com.google.android.gms.cast.framework.media.CastMediaOptions
import com.google.android.gms.cast.framework.media.NotificationOptions
import com.google.android.gms.cast.CastMediaControlIntent

// Casting the live broadcast (flutter_chrome_cast). Used instead of the plugin's own provider, which only has options
// once Dart has set them up: Android may start the Cast reconnection or notification service in a fresh process before
// that, and the plugin's provider would then crash. Same options as the plugin sets (Default Media Receiver), plus a
// notification that opens the app.
class LiveCastOptionsProvider : OptionsProvider {

    override fun getCastOptions(context: Context): CastOptions {
        val notification = NotificationOptions.Builder()
            .setTargetActivityClassName(MainActivity::class.java.name)
            .build()
        return CastOptions.Builder()
            .setReceiverApplicationId(CastMediaControlIntent.DEFAULT_MEDIA_RECEIVER_APPLICATION_ID)
            .setLaunchOptions(LaunchOptions.Builder().setAndroidReceiverCompatible(true).build())
            .setResumeSavedSession(true)
            .setEnableReconnectionService(true)
            .setCastMediaOptions(CastMediaOptions.Builder().setNotificationOptions(notification).build())
            .build()
    }

    override fun getAdditionalSessionProviders(context: Context): List<SessionProvider>? = null
}
