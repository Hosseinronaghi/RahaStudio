package com.rahastudio.raha_studio

import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {
    companion object {
        private const val PICKER_CHANNEL = "com.rahastudio/native_media_picker"
        private const val STORE_CHANNEL = "com.rahastudio/native_media_store"
        private const val PICK_MEDIA_REQUEST = 7001
    }

    private var pendingPickerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PICKER_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickAudioOrVideo" -> openMediaPicker(result)
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            STORE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "publishOutput" -> publishOutput(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun openMediaPicker(result: MethodChannel.Result) {
        if (pendingPickerResult != null) {
            result.error("PICK_IN_PROGRESS", "A picker request is active.", null)
            return
        }

        pendingPickerResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf("audio/*", "video/*", "application/ogg")
            )
        }

        try {
            startActivityForResult(intent, PICK_MEDIA_REQUEST)
        } catch (error: Exception) {
            pendingPickerResult = null
            result.error("PICKER_UNAVAILABLE", error.message, null)
        }
    }

    @Deprecated("Retained for compatibility with FlutterActivity.")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != PICK_MEDIA_REQUEST) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }

        val result = pendingPickerResult
        pendingPickerResult = null
        if (result == null) return

        if (resultCode != Activity.RESULT_OK) {
            result.success(null)
            return
        }

        val uri = data?.data
        if (uri == null) {
            result.error("EMPTY_RESULT", "Selected URI is missing.", null)
            return
        }

        try {
            result.success(copyUriToCache(uri))
        } catch (error: Exception) {
            result.error("COPY_FAILED", error.message, null)
        }
    }

    private fun publishOutput(call: MethodCall, result: MethodChannel.Result) {
        val sourcePath = call.argument<String>("sourcePath")
        val displayName = call.argument<String>("displayName")
        val mimeType = call.argument<String>("mimeType")
        val destination = call.argument<String>("destination") ?: "music"

        if (sourcePath.isNullOrBlank() ||
            displayName.isNullOrBlank() ||
            mimeType.isNullOrBlank()
        ) {
            result.error("INVALID_ARGUMENTS", "Export arguments are incomplete.", null)
            return
        }

        val source = File(sourcePath)
        if (!source.isFile || source.length() <= 0L) {
            result.error("INVALID_SOURCE", "Export source is missing or empty.", null)
            return
        }

        try {
            val isDownloads = destination == "downloads"
            val collection = if (isDownloads) {
                MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            } else {
                MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            }

            val relativePath = if (isDownloads) {
                "${Environment.DIRECTORY_DOWNLOADS}/Raha Studio"
            } else {
                "${Environment.DIRECTORY_MUSIC}/Raha Studio"
            }

            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }

            val uri = requireNotNull(contentResolver.insert(collection, values)) {
                "Android could not create the output file."
            }

            try {
                contentResolver.openOutputStream(uri, "w").use { output ->
                    requireNotNull(output) { "Unable to open output stream." }
                    FileInputStream(source).use { input ->
                        input.copyTo(output)
                    }
                }

                values.clear()
                values.put(MediaStore.MediaColumns.IS_PENDING, 0)
                contentResolver.update(uri, values, null, null)
                result.success("$relativePath/$displayName")
            } catch (error: Exception) {
                contentResolver.delete(uri, null, null)
                throw error
            }
        } catch (error: Exception) {
            result.error("EXPORT_FAILED", error.message, null)
        }
    }

    private fun copyUriToCache(uri: Uri): String {
        val displayName = queryDisplayName(uri)
        val safeName = sanitizeFileName(displayName)
        val importsDir = File(cacheDir, "raha_imports").apply { mkdirs() }
        val destination = uniqueDestination(importsDir, safeName)

        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "Unable to open selected file." }
            FileOutputStream(destination).use { output ->
                input.copyTo(output)
            }
        }

        require(destination.length() > 0L) { "Selected file is empty." }
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
