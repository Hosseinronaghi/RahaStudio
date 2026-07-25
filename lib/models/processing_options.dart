enum RahaPreset { natural, studio, voiceOnly, broadcast, archive }
enum ExportFormat { mp3, wav, m4a, flac }

class ProcessingOptions {
  RahaPreset preset = RahaPreset.studio;
  ExportFormat exportFormat = ExportFormat.mp3;

  bool backgroundNoise = true;
  bool studioSound = true;
  bool deadAir = true;
  bool hum = true;
  bool normalizeLoudness = true;

  // Reserved for later AI/ML phases.
  bool mouthSounds = false;
  bool breaths = false;
  bool fillerWords = false;
  bool stutter = false;
  bool deReverb = false;
  bool voiceIsolation = false;

  double noiseStrength = 0.65;
  double outputLufs = -16.0;
  int mp3BitrateKbps = 192;

  ProcessingOptions copy() {
    final value = ProcessingOptions();
    value
      ..preset = preset
      ..exportFormat = exportFormat
      ..backgroundNoise = backgroundNoise
      ..studioSound = studioSound
      ..deadAir = deadAir
      ..hum = hum
      ..normalizeLoudness = normalizeLoudness
      ..mouthSounds = mouthSounds
      ..breaths = breaths
      ..fillerWords = fillerWords
      ..stutter = stutter
      ..deReverb = deReverb
      ..voiceIsolation = voiceIsolation
      ..noiseStrength = noiseStrength
      ..outputLufs = outputLufs
      ..mp3BitrateKbps = mp3BitrateKbps;
    return value;
  }
}

extension ExportFormatName on ExportFormat {
  String get extension => switch (this) {
    ExportFormat.mp3 => 'mp3',
    ExportFormat.wav => 'wav',
    ExportFormat.m4a => 'm4a',
    ExportFormat.flac => 'flac',
  };
}
