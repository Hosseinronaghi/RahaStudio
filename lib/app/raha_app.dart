import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/raha_theme.dart';
import '../features/home/home_page.dart';
import '../features/import_media/import_media_page.dart';
import '../features/clean_audio/clean_audio_page.dart';
import '../features/projects/projects_page.dart';
import '../features/export/export_page.dart';

class RahaApp extends StatelessWidget {
  const RahaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/import', builder: (_, __) => const ImportMediaPage()),
      GoRoute(path: '/clean', builder: (_, __) => const CleanAudioPage()),
      GoRoute(path: '/projects', builder: (_, __) => const ProjectsPage()),
      GoRoute(path: '/export', builder: (_, __) => const ExportPage()),
    ]);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Raha Studio',
      theme: RahaTheme.light,
      darkTheme: RahaTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      locale: const Locale('fa'),
    );
  }
}
