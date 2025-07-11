// lib/widgets/theme_toggle_button.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() => FloatingActionButton(
          mini: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 2,
          onPressed: () async {
            await themeService.toggleTheme();

            // Mostrar snackbar con icono animado
            Get.snackbar(
              '',
              '',
              titleText: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    themeService.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    themeService.isDarkMode ? 'Modo Oscuro' : 'Modo Claro',
                    style: TextStyle(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              messageText: const SizedBox.shrink(),
              backgroundColor: colorScheme.surface.withOpacity(0.9),
              borderRadius: 8,
              margin: const EdgeInsets.all(16),
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              animationDuration: const Duration(milliseconds: 300),
            );
          },
          child: Icon(
            themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 20,
          ),
        ));
  }
}
