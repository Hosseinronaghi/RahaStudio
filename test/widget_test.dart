import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:raha_studio/app/raha_app.dart';
import 'package:raha_studio/services/app_session.dart';
import 'package:raha_studio/services/project_store.dart';

void main() {
  testWidgets('Raha Studio home screen renders', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProjectStore()),
          ChangeNotifierProvider(create: (_) => AppSession()),
        ],
        child: const RahaApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Raha Studio'), findsOneWidget);
    expect(find.text('پروژه جدید'), findsOneWidget);
  });
}
