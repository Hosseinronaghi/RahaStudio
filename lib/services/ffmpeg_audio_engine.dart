import 'dart:async';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';

import '../models/processing_options.dart';
import 'audio_engine_contract.dart';
import 'ffmpeg_command_builder.dart';

class FfmpegAudioEngine implements AudioEngine {
  FfmpegAudioEngine({
    FfmpegCommandBuilder commandBuilder = const FfmpegCommandBuilder(),
  }) : _commandBuilder = commandBuilder;

  final FfmpegCommandBuilder _commandBuilder;
  int? _activeSessionId;

  @override
  Future<String> process({
    required String sourcePath,
    required String outputPath,
    required ProcessingOptions options,
    void Function(double progress, String stage)? onProgress,
  }) async {
    final command = _commandBuilder.build(
      sourcePath: sourcePath,
      outputPath: outputPath,
      options: options,
    );

    onProgress?.call(0.02, 'شروع Decode');

    final completer = Completer<String>();
    var bestProgress = 0.02;

    final session = await FFmpegKit.executeAsync(
      command,
      (session) async {
        final returnCode = await session.getReturnCode();
        final output = await session.getOutput();
        _activeSessionId = null;

        if (ReturnCode.isSuccess(returnCode)) {
          onProgress?.call(1.0, 'خروجی آماده شد');
          if (!completer.isCompleted) completer.complete(outputPath);
          return;
        }

        if (ReturnCode.isCancel(returnCode)) {
          if (!completer.isCompleted) {
            completer.completeError(
              const AudioProcessingException('پردازش متوقف شد.'),
            );
          }
          return;
        }

        if (!completer.isCompleted) {
          completer.completeError(
            AudioProcessingException(
              'FFmpeg نتوانست خروجی را بسازد.\n${output ?? ''}',
            ),
          );
        }
      },
      (_) {},
      (Statistics statistics) {
        // Without a separate probe pass, exact duration is not guaranteed.
        // This monotonic estimator still gives useful UI feedback.
        final timeMs = statistics.getTime();
        final estimated = (0.08 + (timeMs / 300000.0) * 0.86)
            .clamp(bestProgress, 0.94)
            .toDouble();
        bestProgress = estimated;
        onProgress?.call(estimated, _stage(estimated));
      },
    );

    _activeSessionId = session.getSessionId();
    return completer.future;
  }

  String _stage(double progress) {
    if (progress < 0.18) return 'Decode و تحلیل فایل';
    if (progress < 0.55) return 'حذف نویز و EQ';
    if (progress < 0.78) return 'Compressor و Loudness';
    return 'Encode و ساخت خروجی';
  }

  @override
  Future<void> cancel() async {
    final id = _activeSessionId;
    if (id != null) {
      await FFmpegKit.cancel(id);
      _activeSessionId = null;
    }
  }
}
