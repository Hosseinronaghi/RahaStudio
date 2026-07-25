import 'package:flutter/material.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});
  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  String format = 'MP3';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('خروجی')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: format,
                decoration: const InputDecoration(labelText: 'فرمت'),
                items: const [
                  DropdownMenuItem(value: 'MP3', child: Text('MP3')),
                  DropdownMenuItem(value: 'WAV', child: Text('WAV')),
                  DropdownMenuItem(value: 'M4A', child: Text('M4A')),
                  DropdownMenuItem(value: 'FLAC', child: Text('FLAC')),
                  DropdownMenuItem(value: 'MP4', child: Text('MP4 Video')),
                ],
                onChanged: (v) => setState(() => format = v ?? 'MP3'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('ساخت خروجی'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
