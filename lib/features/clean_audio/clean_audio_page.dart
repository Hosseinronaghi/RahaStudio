import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../models/processing_options.dart';
import '../../services/app_session.dart';
import '../../services/app_settings.dart';
import '../../services/audio_engine_contract.dart';
import '../../services/ffmpeg_audio_engine.dart';
import '../../services/native_media_store.dart';

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
  String stage = '';
  String? outputLocation;

  Widget _option(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool available = true,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        value: value,
        onChanged: available && !processing ? onChanged : null,
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (!available) Chip(label: Text(context.l10n.aiLater)),
          ],
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Future<String> _makeTemporaryOutputPath(String sourcePath) async {
    final baseDir = await getTemporaryDirectory();
    final exportDir = Directory('${baseDir.path}/exports');
    await exportDir.create(recursive: true);
    final sourceName = sourcePath
        .split(RegExp(r'[/\\]'))
        .last
        .replaceFirst(RegExp(r'\.[^.]+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${exportDir.path}/$sourceName-Raha-$timestamp.'
        '${options.exportFormat.extension}';
  }

  String _mimeType(ExportFormat format) => switch (format) {
        ExportFormat.mp3 => 'audio/mpeg',
        ExportFormat.wav => 'audio/wav',
        ExportFormat.m4a => 'audio/mp4',
        ExportFormat.flac => 'audio/flac',
      };

  String _stageText(double value) {
    final t = context.l10n;
    if (value < 0.18) return t.decodeStage;
    if (value < 0.55) return t.denoiseStage;
    if (value < 0.78) return t.dynamicsStage;
    return t.encodeStage;
  }

  Future<void> _process() async {
    final source = context.read<AppSession>().sourcePath;
    final settings = context.read<AppSettings>();
    final t = context.l10n;

    if (source == null || !File(source).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.selectValidFile)),
      );
      return;
    }

    if (settings.exportQuality == ExportQuality.high) {
      options.mp3BitrateKbps = 256;
    } else {
      options.mp3BitrateKbps = 192;
    }

    setState(() {
      processing = true;
      progress = 0;
      stage = t.preparing;
      outputLocation = null;
    });

    File? temporaryFile;
    try {
      final target = await _makeTemporaryOutputPath(source);
      temporaryFile = File(target);

      final result = await engine.process(
        sourcePath: source,
        outputPath: target,
        options: options.copy(),
        onProgress: (value, _) {
          if (!mounted) return;
          setState(() {
            progress = value;
            stage = _stageText(value);
          });
        },
      );

      final resultFile = File(result);
      final displayName = resultFile.path.split(RegExp(r'[/\\]')).last;
      final published = await NativeMediaStore.publish(
        sourcePath: resultFile.path,
        displayName: displayName,
        mimeType: _mimeType(options.exportFormat),
        destination: settings.outputDestination,
      );

      if (!mounted) return;
      context.read<AppSession>().setOutput(published);
      setState(() {
        outputLocation = published;
        progress = 1;
        stage = t.outputReady;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t.savedTo}: $published')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => stage = t.error);
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.processingError),
          content: SelectableText(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.close),
            ),
          ],
        ),
      );
    } finally {
      if (temporaryFile != null && await temporaryFile.exists()) {
        await temporaryFile.delete();
      }
      if (mounted) setState(() => processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final source = context.watch<AppSession>().sourcePath;

    return Scaffold(
      appBar: AppBar(title: Text(t.audioEngine)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.audio_file_rounded),
              title: Text(
                source == null
                    ? t.noFile
                    : source.split(RegExp(r'[/\\]')).last,
              ),
              subtitle: const Text('Decode → Process → Encode'),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<RahaPreset>(
            initialValue: options.preset,
            decoration: InputDecoration(labelText: t.preset),
            items: [
              DropdownMenuItem(
                value: RahaPreset.natural,
                child: Text(t.natural),
              ),
              DropdownMenuItem(
                value: RahaPreset.studio,
                child: Text(t.studio),
              ),
              DropdownMenuItem(
                value: RahaPreset.voiceOnly,
                child: Text(t.voiceOnly),
              ),
              DropdownMenuItem(
                value: RahaPreset.broadcast,
                child: Text(t.broadcast),
              ),
              DropdownMenuItem(
                value: RahaPreset.archive,
                child: Text(t.archive),
              ),
            ],
            onChanged: processing
                ? null
                : (value) {
                    setState(() {
                      options.preset = value ?? RahaPreset.studio;
                    });
                  },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ExportFormat>(
            initialValue: options.exportFormat,
            decoration: InputDecoration(labelText: t.outputFormat),
            items: const [
              DropdownMenuItem(
                value: ExportFormat.mp3,
                child: Text('MP3'),
              ),
              DropdownMenuItem(
                value: ExportFormat.wav,
                child: Text('WAV'),
              ),
              DropdownMenuItem(
                value: ExportFormat.m4a,
                child: Text('M4A / AAC'),
              ),
              DropdownMenuItem(
                value: ExportFormat.flac,
                child: Text('FLAC'),
              ),
            ],
            onChanged: processing
                ? null
                : (value) {
                    setState(() {
                      options.exportFormat = value ?? ExportFormat.mp3;
                    });
                  },
          ),
          const SizedBox(height: 16),
          _option(
            t.backgroundNoise,
            t.backgroundNoiseSubtitle,
            options.backgroundNoise,
            (value) => setState(() => options.backgroundNoise = value),
          ),
          if (options.backgroundNoise) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${t.intensity}: ${(options.noiseStrength * 100).round()}%',
              ),
            ),
            Slider(
              value: options.noiseStrength,
              onChanged: processing
                  ? null
                  : (value) {
                      setState(() => options.noiseStrength = value);
                    },
            ),
          ],
          _option(
            t.studioSound,
            t.studioSoundSubtitle,
            options.studioSound,
            (value) => setState(() => options.studioSound = value),
          ),
          _option(
            t.removeHum,
            t.removeHumSubtitle,
            options.hum,
            (value) => setState(() => options.hum = value),
          ),
          _option(
            t.trimSilence,
            t.trimSilenceSubtitle,
            options.deadAir,
            (value) => setState(() => options.deadAir = value),
          ),
          _option(
            t.loudness,
            t.loudnessSubtitle,
            options.normalizeLoudness,
            (value) => setState(() => options.normalizeLoudness = value),
          ),
          _option(
            t.aiFeatures,
            '',
            false,
            (_) {},
            available: false,
          ),
          const SizedBox(height: 12),
          if (processing) ...[
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 10),
            Text('${(progress * 100).round()}% — $stage'),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: engine.cancel,
              icon: const Icon(Icons.stop_circle_outlined),
              label: Text(t.stopProcessing),
            ),
          ] else
            FilledButton.icon(
              onPressed: _process,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(t.startProcessing),
            ),
          if (outputLocation != null) ...[
            const SizedBox(height: 14),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: Text(t.outputReady),
                subtitle: SelectableText(outputLocation!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
