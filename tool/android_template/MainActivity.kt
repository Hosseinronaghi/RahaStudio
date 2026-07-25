package com.rahastudio.raha_studio

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.rahastudio/native_media_picker"
        private const val PICK_MEDIA_REQUEST = 7001
    }

    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "pickAudioOrVideo" -> openMediaPicker(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun openMediaPicker(result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error(
                "PICK_IN_PROGRESS",
                "A file picker request is already active.",
                null
            )
            return
        }

        pendingResult = result

        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf(
                    "audio/*",
                    "video/*",
                    "application/ogg"
                )
            )
        }

        try {
            startActivityForResult(intent, PICK_MEDIA_REQUEST)
        } catch (error: Exception) {
            pendingResult = null
            result.error(
                "PICKER_UNAVAILABLE",
                error.message ?: "No compatible file picker is available.",
                null
            )
        }
    }

    @Deprecated("Deprecated in Android SDK, retained for broad compatibility.")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != PICK_MEDIA_REQUEST) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }

        val result = pendingResult
        pendingResult = null

        if (result == null) return

        if (resultCode != Activity.RESULT_OK) {
            result.success(null)
            return
        }

        val uri = data?.data
        if (uri == null) {
            result.error("EMPTY_RESULT", "The selected file URI is missing.", null)
            return
        }

        try {
            result.success(copyUriToCache(uri))
        } catch (error: Exception) {
            result.error(
                "COPY_FAILED",
                error.message ?: "The selected file could not be copied.",
                null
            )
        }
    }

    private fun copyUriToCache(uri: Uri): String {
        val displayName = queryDisplayName(uri)
        val safeName = sanitizeFileName(displayName)
        val importsDir = File(cacheDir, "raha_imports").apply { mkdirs() }
        val destination = uniqueDestination(importsDir, safeName)

        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "Unable to open the selected file." }
            FileOutputStream(destination).use { output ->
                input.copyTo(output)
            }
        }

        require(destination.length() > 0L) { "The selected file is empty." }
        return destination.absolutePath
    }

    private fun queryDisplayName(uri: Uri): String {
        var cursor: Cursor? = null
        return try {
            cursor = contentResolver.query(
                uri,
                arrayOf(OpenableColumns.DISPLAY_NAME),
                null,
                null,
                null
            )

            if (cursor != null && cursor.moveToFirst()) {
                val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (index >= 0) cursor.getString(index) ?: fallbackName(uri)
                else fallbackName(uri)
            } else {
                fallbackName(uri)
            }
        } finally {
            cursor?.close()
        }
    }

    private fun fallbackName(uri: Uri): String {
        val extension = contentResolver
            .getType(uri)
            ?.substringAfterLast('/', "")
            ?.lowercase(Locale.US)
            ?.takeIf { it.isNotBlank() }
            ?: "media"

        return "import_${System.currentTimeMillis()}.$extension"
    }

    private fun sanitizeFileName(value: String): String {
        val cleaned = value
            .replace(Regex("[^A-Za-z0-9._() -]"), "_")
            .trim()
            .take(120)

        return cleaned.ifBlank { "import_${System.currentTimeMillis()}.media" }
    }

    private fun uniqueDestination(directory: File, fileName: String): File {
        var candidate = File(directory, fileName)
        if (!candidate.exists()) return candidate

        val dot = fileName.lastIndexOf('.')
        val base = if (dot > 0) fileName.substring(0, dot) else fileName
        val extension = if (dot > 0) fileName.substring(dot) else ""

        var counter = 1
        while (candidate.exists()) {
            candidate = File(directory, "${base}_$counter$extension")
            counter += 1
        }
        return candidate
    }
}
