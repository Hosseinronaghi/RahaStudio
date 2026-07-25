import 'package:flutter/services.dart';

import 'app_settings.dart';

class NativeMediaStore {
  NativeMediaStore._();

  static const MethodChannel _channel =
      MethodChannel('com.rahastudio/native_media_store');

  static Future<String> publish({
    required String sourcePath,
    required String displayName,
    required String mimeType,
    required OutputDestination destination,
  }) async {
    final result = await _channel.invokeMethod<String>('publishOutput', {
      'sourcePath': sourcePath,
      'displayName': displayName,
      'mimeType': mimeType,
      'destination': destination.name,
    });

    if (result == null || result.isEmpty) {
      throw const PlatformException(
        code: 'EMPTY_EXPORT_RESULT',
        message: 'Android did not return the saved file location.',
      );
    }
    return result;
  }
}
