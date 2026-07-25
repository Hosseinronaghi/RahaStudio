import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OutputDestination { music, downloads }
enum ExportQuality { standard, high }

class AppSettings extends ChangeNotifier {
  static const _localeKey = 'locale';
  static const _themeKey = 'theme_mode';
  static const _destinationKey = 'output_destination';
  static const _qualityKey = 'export_quality';

  Locale _locale = const Locale('fa');
  ThemeMode _themeMode = ThemeMode.system;
  OutputDestination _outputDestination = OutputDestination.music;
  ExportQuality _exportQuality = ExportQuality.high;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  OutputDestination get outputDestination => _outputDestination;
  ExportQuality get exportQuality => _exportQuality;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(prefs.getString(_localeKey) ?? 'fa');
    _themeMode = ThemeMode.values.firstWhere(
      (value) => value.name == prefs.getString(_themeKey),
      orElse: () => ThemeMode.system,
    );
    _outputDestination = OutputDestination.values.firstWhere(
      (value) => value.name == prefs.getString(_destinationKey),
      orElse: () => OutputDestination.music,
    );
    _exportQuality = ExportQuality.values.firstWhere(
      (value) => value.name == prefs.getString(_qualityKey),
      orElse: () => ExportQuality.high,
    );
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    _locale = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, value.languageCode);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, value.name);
  }

  Future<void> setOutputDestination(OutputDestination value) async {
    _outputDestination = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_destinationKey, value.name);
  }

  Future<void> setExportQuality(ExportQuality value) async {
    _exportQuality = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_qualityKey, value.name);
  }
}
