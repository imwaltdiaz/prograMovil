// lib/services/theme_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static const String _themeKey = 'theme_mode';

  // Estado reactivo del tema
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  // Getter para saber si está en modo oscuro
  bool get isDarkMode {
    switch (_themeMode.value) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return Get.context != null &&
            MediaQuery.of(Get.context!).platformBrightness == Brightness.dark;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadThemeFromPrefs();
  }

  /// Cargar tema guardado desde SharedPreferences
  Future<void> loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);

      if (themeString != null) {
        _themeMode.value = _parseThemeMode(themeString);
        print('>> [ThemeService] Tema cargado: ${_themeMode.value}');
      } else {
        print(
            '>> [ThemeService] No hay tema guardado, usando sistema por defecto');
      }
    } catch (e) {
      print('>> [ThemeService] Error cargando tema: $e');
    }
  }

  /// Cambiar tema y guardar en SharedPreferences
  Future<void> changeTheme(ThemeMode themeMode) async {
    try {
      _themeMode.value = themeMode;

      // Aplicar el tema inmediatamente
      Get.changeThemeMode(themeMode);

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeToString(themeMode));

      print('>> [ThemeService] Tema cambiado a: $themeMode');
    } catch (e) {
      print('>> [ThemeService] Error cambiando tema: $e');
    }
  }

  /// Alternar entre claro y oscuro
  Future<void> toggleTheme() async {
    final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await changeTheme(newTheme);
  }

  /// Convertir ThemeMode a String
  String _themeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convertir String a ThemeMode
  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Obtener el nombre legible del tema actual
  String get currentThemeName {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }
}
