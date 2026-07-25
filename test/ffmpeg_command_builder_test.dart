import 'package:flutter_test/flutter_test.dart';
import 'package:raha_studio/models/processing_options.dart';
import 'package:raha_studio/services/ffmpeg_command_builder.dart';

void main() {
  test('builds the complete real processing chain', () {
    final options = ProcessingOptions()
      ..exportFormat = ExportFormat.mp3
      ..backgroundNoise = true
      ..studioSound = true
      ..hum = true
      ..deadAir = true
      ..normalizeLoudness = true;

    final command = const FfmpegCommandBuilder().build(
      sourcePath: '/input/voice.wav',
      outputPath: '/output/voice.mp3',
      options: options,
    );

    expect(command, contains('afftdn='));
    expect(command, contains('equalizer=f=3200'));
    expect(command, contains('acompressor='));
    expect(command, contains('loudnorm='));
    expect(command, contains('silenceremove='));
    expect(command, contains('libmp3lame'));
  });
}
