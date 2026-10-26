package com.ktk.dukapp

import android.content.ContentValues
import android.os.Environment
import android.provider.MediaStore
import com.ryanheise.audioservice.AudioServiceFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// The activity of just_audio_background (audio-only live streams keep playing with the screen off); the Fragment
// variant because local_auth (biometric unlock) needs a FragmentActivity
class MainActivity: AudioServiceFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dukapp/downloads").setMethodCallHandler { call, result ->
            if (call.method != "save") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                result.success(
                    saveToDownloads(
                        call.argument<String>("name")!!,
                        call.argument<String>("mimeType")!!,
                        call.argument<ByteArray>("bytes")!!,
                    )
                )
            } catch (e: Exception) {
                result.error("SaveFailed", e.message, null)
            }
        }
    }

    /**
     * Puts the file into Downloads with the given type, like a browser download (no permission needed from Android 10
     * on). Android's scan on publishing replaces the type with its own guess from the extension, for .csv
     * "text/comma-separated-values", and file pickers asking for text/csv (the MyShare import) then grey the file out;
     * setting the type again after publishing keeps it, as Chrome's downloads do. Returns the name it got (Android adds
     * " (1)" when the name is taken).
     */
    private fun saveToDownloads(name: String, mimeType: String, bytes: ByteArray): String {
        val resolver = contentResolver
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, name)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }) ?: throw IllegalStateException("Downloads refused the file")
        try {
            resolver.openOutputStream(uri, "wt")?.use { it.write(bytes) }
                ?: throw IllegalStateException("Unable to open the file")
            resolver.update(uri, ContentValues().apply { put(MediaStore.MediaColumns.IS_PENDING, 0) }, null, null)
            resolver.update(uri, ContentValues().apply { put(MediaStore.MediaColumns.MIME_TYPE, mimeType) }, null, null)
        } catch (e: Exception) {
            resolver.delete(uri, null, null)
            throw e
        }
        resolver.query(uri, arrayOf(MediaStore.MediaColumns.DISPLAY_NAME), null, null, null)?.use {
            if (it.moveToFirst()) return it.getString(0)
        }
        return name
    }
}
