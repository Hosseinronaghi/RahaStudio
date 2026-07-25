import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
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
        SnackBar(content: Text(error.message ?? context.l10n.error)),
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
    final t = context.l10n;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.importFile)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
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
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isPicking)
                        const CircularProgressIndicator()
                      else
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.audio_file_rounded,
                            size: 38,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        selectedPath == null
                            ? t.chooseMedia
                            : selectedPath!.split(RegExp(r'[/\\]')).last,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t.chooseMediaHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
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
                child: Text(t.continueLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
