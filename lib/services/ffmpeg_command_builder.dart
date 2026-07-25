import '../models/processing_options.dart';

class FfmpegCommandBuilder {
  const FfmpegCommandBuilder();

  String build({
    required String sourcePath,
    required String outputPath,
    required ProcessingOptions options,
  }) {
    final filters = <String>[];

    final preset = _preset(options.preset);
    filters
      ..add('highpass=f=${preset.highPassHz}')
      ..add('lowpass=f=${preset.lowPassHz}');

    if (options.hum) {
      // Narrow notches for the common 50 Hz mains frequency and harmonics.
      filters
        ..add('equalizer=f=50:t=q:w=10:g=-18')
        ..add('equalizer=f=100:t=q:w=10:g=-12')
        ..add('equalizer=f=150:t=q:w=10:g=-8');
    }

    if (options.backgroundNoise) {
      // FFmpeg's FFT denoiser. The nf value becomes more negative as
      // strength increases. Conservative bounds reduce speech artifacts.
      final strength = options.noiseStrength.clamp(0.0, 1.0);
      final noiseFloor = -22.0 - (strength * 12.0);
      filters.add('afftdn=nf=${noiseFloor.toStringAsFixed(1)}:tn=1:gs=6');
    }

    if (options.studioSound) {
      filters
        ..add(
          'equalizer=f=180:t=q:w=1.0:g=${preset.warmthDb.toStringAsFixed(1)}',
        )
        ..add(
          'equalizer=f=3200:t=q:w=1.2:g=${preset.presenceDb.toStringAsFixed(1)}',
        )
        ..add(
          'acompressor='
          'threshold=-20dB:'
          'ratio=${preset.compressorRatio.toStringAsFixed(1)}:'
          'attack=18:release=220:makeup=1.5',
        );
    }

    if (options.deadAir) {
      // Removes only leading/trailing silence; it does not destructively
      // shorten natural pauses inside the speech.
      filters.add(
        'silenceremove='
        'start_periods=1:start_duration=0.25:start_threshold=-48dB:'
        'stop_periods=1:stop_duration=0.8:stop_threshold=-48dB',
      );
    }

    if (options.normalizeLoudness) {
      filters.add(
        'loudnorm='
        'I=${options.outputLufs.toStringAsFixed(1)}:'
        'TP=-1.5:LRA=7',
      );
    }

    final codec = _codec(options);
    return [
      '-hide_banner',
      '-y',
      '-i', _quote(sourcePath),
      '-vn',
      '-af', _quote(filters.join(',')),
      '-ar', '48000',
      ...codec,
      _quote(outputPath),
    ].join(' ');
  }

  List<String> _codec(ProcessingOptions options) {
    return switch (options.exportFormat) {
      ExportFormat.mp3 => [
          '-c:a', 'libmp3lame',
          '-b:a', '${options.mp3BitrateKbps}k',
        ],
      ExportFormat.wav => ['-c:a', 'pcm_s24le'],
      ExportFormat.m4a => ['-c:a', 'aac', '-b:a', '192k'],
      ExportFormat.flac => ['-c:a', 'flac', '-compression_level', '8'],
    };
  }

  _Preset _preset(RahaPreset preset) => switch (preset) {
    RahaPreset.natural => const _Preset(70, 14500, 0.5, 1.0, 1.7),
    RahaPreset.studio => const _Preset(80, 12500, 0.8, 2.0, 2.3),
    RahaPreset.voiceOnly => const _Preset(95, 9500, 0.2, 2.7, 3.0),
    RahaPreset.broadcast => const _Preset(75, 13000, 1.5, 2.2, 2.8),
    RahaPreset.archive => const _Preset(55, 15500, 0.0, 0.5, 1.3),
  };

  String _quote(String value) => '"${value.replaceAll('"', r'\"')}"';
}

class _Preset {
  const _Preset(
    this.highPassHz,
    this.lowPassHz,
    this.warmthDb,
    this.presenceDb,
    this.compressorRatio,
  );

  final int highPassHz;
  final int lowPassHz;
  final double warmthDb;
  final double presenceDb;
  final double compressorRatio;
}
