import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/project_store.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectStore>().projects;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('پروژه‌ها')),
        body: projects.isEmpty
          ? const Center(child: Text('هنوز پروژه‌ای ساخته نشده است.'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: projects.length,
              itemBuilder: (_, i) {
                final p = projects[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.audiotrack),
                    title: Text(p.title),
                    subtitle: Text(p.createdAt.toLocal().toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context.read<ProjectStore>().remove(p.id),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
