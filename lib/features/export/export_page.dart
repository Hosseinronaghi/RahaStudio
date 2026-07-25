import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../services/app_session.dart';
import '../../services/app_settings.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final output = context.watch<AppSession>().lastOutputPath;
    final destination = context.watch<AppSettings>().outputDestination;

    return Scaffold(
      appBar: AppBar(title: Text(t.export)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(t.saveLocation),
              subtitle: Text(
                destination == OutputDestination.music
                    ? t.musicFolder
                    : t.downloadsFolder,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: Text(output == null ? t.noFile : t.outputReady),
              subtitle: output == null ? null : SelectableText(output),
            ),
          ),
        ],
      ),
    );
  }
}
