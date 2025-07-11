// lib/pages/theme_settings/theme_settings_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/theme_service.dart';

class ThemeSettingsController extends GetxController {
  final ThemeService _themeService = Get.find<ThemeService>();

  // Tema seleccionado actualmente
  Rx<ThemeMode> selectedTheme = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar con el tema actual
    selectedTheme.value = _themeService.themeMode;
  }

  /// Cambiar tema
  Future<void> changeTheme(ThemeMode themeMode) async {
    selectedTheme.value = themeMode;
    await _themeService.changeTheme(themeMode);

    // Mostrar snackbar de confirmación
    Get.snackbar(
      'Tema Cambiado',
      'Se ha aplicado el tema ${_getThemeName(themeMode)}',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.onBackground,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: Icon(
        _getThemeIcon(themeMode),
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  /// Obtener el nombre del tema
  String _getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }

  /// Obtener el icono del tema
  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Obtener el nombre del tema actual
  String get currentThemeName => _themeService.currentThemeName;
}
