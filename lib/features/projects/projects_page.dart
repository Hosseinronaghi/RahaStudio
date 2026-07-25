import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_strings.dart';
import '../../services/project_store.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final projects = context.watch<ProjectStore>().projects;

    return Scaffold(
      appBar: AppBar(title: Text(t.projects)),
      body: projects.isEmpty
          ? Center(child: Text(t.noProjects))
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final project = projects[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.graphic_eq_rounded),
                    title: Text(project.title),
                    subtitle: Text(project.createdAt.toLocal().toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        context.read<ProjectStore>().remove(project.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
