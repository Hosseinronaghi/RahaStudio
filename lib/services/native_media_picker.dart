import 'package:flutter/services.dart';

class NativeMediaPicker {
  NativeMediaPicker._();

  static const MethodChannel _channel =
      MethodChannel('com.rahastudio/native_media_picker');

  static Future<String?> pickAudioOrVideo() async {
    return _channel.invokeMethod<String>('pickAudioOrVideo');
  }
}
