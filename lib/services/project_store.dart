import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/raha_project.dart';

class ProjectStore extends ChangeNotifier {
  static const _key = 'raha_projects_v1';
  final List<RahaProject> _projects = [];
  List<RahaProject> get projects => List.unmodifiable(_projects);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final data = jsonDecode(raw) as List<dynamic>;
      _projects
        ..clear()
        ..addAll(data.map((e) => RahaProject.fromJson(e)));
    }
    notifyListeners();
  }

  Future<void> create(String title, String path) async {
    _projects.insert(0, RahaProject(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      sourcePath: path,
    ));
    await _save();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _projects.removeWhere((e) => e.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_projects.map((e) => e.toJson()).toList()),
    );
  }
}
