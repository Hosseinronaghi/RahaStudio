import 'package:flutter/foundation.dart';

class AppSession extends ChangeNotifier {
  String? _sourcePath;
  String? _lastOutputPath;

  String? get sourcePath => _sourcePath;
  String? get lastOutputPath => _lastOutputPath;

  void setSource(String path) {
    _sourcePath = path;
    _lastOutputPath = null;
    notifyListeners();
  }

  void setOutput(String path) {
    _lastOutputPath = path;
    notifyListeners();
  }
}
