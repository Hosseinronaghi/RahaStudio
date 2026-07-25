import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appName),
        actions: [
          IconButton(
            tooltip: t.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.graphic_eq_rounded,
                    size: 34,
                    color: colors.onPrimaryContainer,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    t.homeHeadline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.homeSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colors.onPrimaryContainer.withValues(alpha: 0.82),
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/import'),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(t.newProject),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              t.privateAudioStudio,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _actionCard(
              context,
              icon: Icons.auto_awesome_rounded,
              title: t.cleanAudio,
              subtitle: t.cleanAudioSubtitle,
              route: '/import',
            ),
            const SizedBox(height: 12),
            _actionCard(
              context,
              icon: Icons.folder_copy_outlined,
              title: t.projects,
              subtitle: t.projectsSubtitle,
              route: '/projects',
            ),
            const SizedBox(height: 12),
            _actionCard(
              context,
              icon: Icons.ios_share_rounded,
              title: t.export,
              subtitle: t.exportSubtitle,
              route: '/export',
            ),
            const SizedBox(height: 12),
            _actionCard(
              context,
              icon: Icons.settings_outlined,
              title: t.settings,
              subtitle: t.settingsSubtitle,
              route: '/settings',
            ),
          ],
        ),
      ),
    );
  }
}
