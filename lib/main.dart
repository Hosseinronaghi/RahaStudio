import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/raha_app.dart';
import 'services/app_session.dart';
import 'services/project_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectStore()..load()),
        ChangeNotifierProvider(create: (_) => AppSession()),
      ],
      child: const RahaApp(),
    ),
  );
}
