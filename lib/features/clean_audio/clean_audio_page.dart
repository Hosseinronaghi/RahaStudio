import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/processing_options.dart';
import '../../services/app_session.dart';
import '../../services/audio_engine_contract.dart';
import '../../services/ffmpeg_audio_engine.dart';

class CleanAudioPage extends StatefulWidget {
  const CleanAudioPage({super.key});

  @override
  State<CleanAudioPage> createState() => _CleanAudioPageState();
}

class _CleanAudioPageState extends State<CleanAudioPage> {
  final options = ProcessingOptions();
  final AudioEngine engine = FfmpegAudioEngine();

  bool processing = false;
  double progress = 0;
  String stage = 'آماده';
  String? outputPath;

  Widget option(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool available = true,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: available && !processing ? onChanged : null,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (!available) const Chip(label: Text('فاز بعد')),
        ],
      ),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<String> _makeOutputPath(String sourcePath) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${baseDir.path}/RahaStudio/exports');
    await exportDir.create(recursive: true);

    final sourceName = sourcePath
        .split(RegExp(r'[/\\]'))
        .last
        .replaceFirst(RegExp(r'\.[^.]+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${exportDir.path}/$sourceName-Raha-$timestamp.'
        '${options.exportFormat.extension}';
  }

  Future<void> _process() async {
    final source = context.read<AppSession>().sourcePath;
    if (source == null || !File(source).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ابتدا یک فایل معتبر وارد کنید.')),
      );
      return;
    }

    setState(() {
      processing = true;
      progress = 0;
      stage = 'آماده‌سازی';
      outputPath = null;
    });

    try {
      final target = await _makeOutputPath(source);
      final result = await engine.process(
        sourcePath: source,
        outputPath: target,
        options: options.copy(),
        onProgress: (value, text) {
          if (!mounted) return;
          setState(() {
            progress = value;
            stage = text;
          });
        },
      );
      if (!mounted) return;
      context.read<AppSession>().setOutput(result);
      setState(() {
        outputPath = result;
        progress = 1;
        stage = 'خروجی آماده شد';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فایل ساخته شد:\n$result')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => stage = 'خطا');
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('خطا در پردازش'),
          content: SelectableText(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('بستن'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final source = context.watch<AppSession>().sourcePath;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('موتور صوت Raha')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.audiotrack),
                title: Text(
                  source == null
                      ? 'فایلی انتخاب نشده'
                      : source.split(RegExp(r'[/\\]')).last,
                ),
                subtitle: const Text('Decode → Process → Encode'),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<RahaPreset>(
              value: options.preset,
              decoration: const InputDecoration(labelText: 'Preset'),
              items: const [
                DropdownMenuItem(
                  value: RahaPreset.natural,
                  child: Text('Natural'),
                ),
                DropdownMenuItem(
                  value: RahaPreset.studio,
                  child: Text('Studio'),
                ),
                DropdownMenuItem(
                  value: RahaPreset.voiceOnly,
                  child: Text('Voice Only'),
                ),
                DropdownMenuItem(
                  value: RahaPreset.broadcast,
                  child: Text('Broadcast'),
                ),
                DropdownMenuItem(
                  value: RahaPreset.archive,
                  child: Text('Archive'),
                ),
              ],
              onChanged: processing
                  ? null
                  : (value) => setState(
                        () => options.preset = value ?? RahaPreset.studio,
                      ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExportFormat>(
              value: options.exportFormat,
              decoration: const InputDecoration(labelText: 'فرمت خروجی'),
              items: const [
                DropdownMenuItem(
                  value: ExportFormat.mp3,
                  child: Text('MP3 — 192 kbps'),
                ),
                DropdownMenuItem(
                  value: ExportFormat.wav,
                  child: Text('WAV — 24-bit'),
                ),
                DropdownMenuItem(
                  value: ExportFormat.m4a,
                  child: Text('M4A / AAC'),
                ),
                DropdownMenuItem(
                  value: ExportFormat.flac,
                  child: Text('FLAC Lossless'),
                ),
              ],
              onChanged: processing
                  ? null
                  : (value) => setState(
                        () => options.exportFormat =
                            value ?? ExportFormat.mp3,
                      ),
            ),
            const SizedBox(height: 16),
            option(
              'حذف نویز پس‌زمینه',
              'FFT Denoiser برای فن، هیس و نویز محیط',
              options.backgroundNoise,
              (v) => setState(() => options.backgroundNoise = v),
            ),
            if (options.backgroundNoise) ...[
              Text('شدت: ${(options.noiseStrength * 100).round()}٪'),
              Slider(
                value: options.noiseStrength,
                onChanged: processing
                    ? null
                    : (v) => setState(() => options.noiseStrength = v),
              ),
            ],
            option(
              'Studio Sound',
              'EQ گفتار و Compressor دینامیکی',
              options.studioSound,
              (v) => setState(() => options.studioSound = v),
            ),
            option(
              'حذف Hum',
              'Notch Filter در 50، 100 و 150 هرتز',
              options.hum,
              (v) => setState(() => options.hum = v),
            ),
            option(
              'کاهش سکوت ابتدا و انتها',
              'Silence Removal محافظه‌کارانه',
              options.deadAir,
              (v) => setState(() => options.deadAir = v),
            ),
            option(
              'Loudness Normalization',
              'استاندارد -16 LUFS و True Peak برابر -1.5 dB',
              options.normalizeLoudness,
              (v) => setState(() => options.normalizeLoudness = v),
            ),
            option(
              'Mouth Sounds / Breath / Filler Words',
              'برای نتیجه دقیق به مدل‌های AI نیاز دارد',
              false,
              (_) {},
              available: false,
            ),
            const SizedBox(height: 18),
            if (processing) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text('${(progress * 100).round()}٪ — $stage'),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => engine.cancel(),
                icon: const Icon(Icons.stop),
                label: const Text('توقف پردازش'),
              ),
            ] else
              FilledButton.icon(
                onPressed: _process,
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('پردازش واقعی و ساخت خروجی'),
              ),
            if (outputPath != null) ...[
              const SizedBox(height: 14),
              SelectableText('خروجی:\n$outputPath'),
            ],
          ],
        ),
      ),
    );
  }
}
