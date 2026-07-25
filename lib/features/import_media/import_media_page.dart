import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/app_session.dart';
import '../../services/native_media_picker.dart';
import '../../services/project_store.dart';

class ImportMediaPage extends StatefulWidget {
  const ImportMediaPage({super.key});

  @override
  State<ImportMediaPage> createState() => _ImportMediaPageState();
}

class _ImportMediaPageState extends State<ImportMediaPage> {
  String? selectedPath;
  bool isPicking = false;

  Future<void> _pick() async {
    if (isPicking) return;

    setState(() => isPicking = true);
    try {
      final path = await NativeMediaPicker.pickAudioOrVideo();
      if (!mounted || path == null || path.isEmpty) return;
      setState(() => selectedPath = path);
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'انتخاب فایل با خطا روبه‌رو شد.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isPicking = false);
    }
  }

  Future<void> _continue() async {
    final path = selectedPath;
    if (path == null) return;

    context.read<AppSession>().setSource(path);
    await context.read<ProjectStore>().create(
      path.split(RegExp(r'[/\\]')).last,
      path,
    );

    if (mounted) context.go('/clean');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('وارد کردن فایل')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: isPicking ? null : _pick,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPicking)
                          const CircularProgressIndicator()
                        else
                          const Icon(Icons.upload_file, size: 64),
                        const SizedBox(height: 18),
                        Text(
                          selectedPath == null
                              ? 'فایل صوتی یا ویدئویی را انتخاب کن'
                              : selectedPath!
                                  .split(RegExp(r'[/\\]'))
                                  .last,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Audio: MP3, WAV, M4A, AAC, FLAC, OGG — '
                          'Video: MP4, MOV, MKV, WEBM',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      selectedPath == null || isPicking ? null : _continue,
                  child: const Text('ادامه'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
