import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/raha_app.dart';
import 'services/app_session.dart';
import 'services/app_settings.dart';
import 'services/project_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = AppSettings();
  await settings.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectStore()..load()),
        ChangeNotifierProvider(create: (_) => AppSession()),
        ChangeNotifierProvider.value(value: settings),
      ],
      child: const RahaApp(),
    ),
  );
}
