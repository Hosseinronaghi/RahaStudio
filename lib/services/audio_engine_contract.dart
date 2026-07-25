import '../models/processing_options.dart';

class AudioProcessingException implements Exception {
  const AudioProcessingException(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class AudioEngine {
  Future<String> process({
    required String sourcePath,
    required String outputPath,
    required ProcessingOptions options,
    void Function(double progress, String stage)? onProgress,
  });

  Future<void> cancel();
}
