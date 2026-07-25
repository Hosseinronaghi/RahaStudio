import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../services/app_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          _Section(
            title: t.language,
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'fa', label: Text(t.persian)),
                ButtonSegment(value: 'en', label: Text(t.english)),
              ],
              selected: {settings.locale.languageCode},
              onSelectionChanged: (values) {
                settings.setLocale(Locale(values.first));
              },
            ),
          ),
          _Section(
            title: t.appearance,
            child: DropdownButtonFormField<ThemeMode>(
              initialValue: settings.themeMode,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(t.systemTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(t.lightTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(t.darkTheme),
                ),
              ],
              onChanged: (value) {
                if (value != null) settings.setThemeMode(value);
              },
            ),
          ),
          _Section(
            title: t.saveLocation,
            child: SegmentedButton<OutputDestination>(
              segments: [
                ButtonSegment(
                  value: OutputDestination.music,
                  icon: const Icon(Icons.library_music_outlined),
                  label: Text(t.musicFolder),
                ),
                ButtonSegment(
                  value: OutputDestination.downloads,
                  icon: const Icon(Icons.download_outlined),
                  label: Text(t.downloadsFolder),
                ),
              ],
              selected: {settings.outputDestination},
              onSelectionChanged: (values) {
                settings.setOutputDestination(values.first);
              },
            ),
          ),
          _Section(
            title: t.defaultQuality,
            child: SegmentedButton<ExportQuality>(
              segments: [
                ButtonSegment(
                  value: ExportQuality.standard,
                  label: Text(t.standardQuality),
                ),
                ButtonSegment(
                  value: ExportQuality.high,
                  label: Text(t.highQuality),
                ),
              ],
              selected: {settings.exportQuality},
              onSelectionChanged: (values) {
                settings.setExportQuality(values.first);
              },
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user_outlined),
                      const SizedBox(width: 10),
                      Text(
                        t.privacy,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(t.privacyDetails),
                  const SizedBox(height: 8),
                  Text(
                    t.signingWarning,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
