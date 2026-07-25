import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/app_session.dart';
import '../../services/project_store.dart';

class ImportMediaPage extends StatefulWidget {
  const ImportMediaPage({super.key});

  @override
  State<ImportMediaPage> createState() => _ImportMediaPageState();
}

class _ImportMediaPageState extends State<ImportMediaPage> {
  String? selectedPath;

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3', 'wav', 'm4a', 'aac', 'flac', 'ogg',
        'mp4', 'mov', 'mkv', 'webm',
      ],
    );
    final path = result?.files.single.path;
    if (path != null) setState(() => selectedPath = path);
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
                  onTap: _pick,
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
                        const Text('Audio: MP3, WAV, M4A, FLAC — Video: MP4, MOV'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: selectedPath == null ? null : _continue,
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
