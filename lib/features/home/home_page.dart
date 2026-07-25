import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget tile(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => context.push(route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Raha Studio')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'از صدا تا انتشار،\nهمه در یک استودیو',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 14),
                  const Text('وارد کردن، پاک‌سازی، تدوین و آماده‌سازی محتوا'),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => context.push('/import'),
                    icon: const Icon(Icons.add),
                    label: const Text('پروژه جدید'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            tile(context, Icons.auto_fix_high, 'پاک‌سازی صدا',
              'نویز، سکوت، صدای دهان، هوم و بلندی صدا', '/clean'),
            tile(context, Icons.folder_outlined, 'پروژه‌ها',
              'مدیریت فایل‌ها و خروجی‌ها', '/projects'),
            tile(context, Icons.ios_share, 'خروجی',
              'MP3، WAV، M4A، FLAC و ویدئو', '/export'),
          ],
        ),
      ),
    );
  }
}
