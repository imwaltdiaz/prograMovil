// lib/pages/theme_settings/theme_settings_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_settings_controller.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeSettingsController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Configuración de Tema',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono de tema
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.palette,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Personaliza la apariencia de la aplicación según tus preferencias.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ─── Sección de opciones de tema ─────────────────────────────
              Text(
                'Modo de Tema',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ─── Opción CLARO ─────────────────────────────
              Obx(
                () => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.light_mode,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Claro',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Ideal para uso durante el día',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: controller.selectedTheme.value,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          controller.changeTheme(value);
                        }
                      },
                      activeColor: colorScheme.primary,
                    ),
                    onTap: () => controller.changeTheme(ThemeMode.light),
                  ),
                ),
              ),

              // ─── Opción OSCURO ─────────────────────────────
              Obx(
                () => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.dark_mode,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Oscuro',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Ideal para uso nocturno y ahorro de batería',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: controller.selectedTheme.value,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          controller.changeTheme(value);
                        }
                      },
                      activeColor: colorScheme.primary,
                    ),
                    onTap: () => controller.changeTheme(ThemeMode.dark),
                  ),
                ),
              ),

              // ─── Opción SISTEMA ─────────────────────────────
              Obx(
                () => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.grey.shade800],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.brightness_auto,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Automático (Sistema)',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Sigue la configuración del sistema',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: controller.selectedTheme.value,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          controller.changeTheme(value);
                        }
                      },
                      activeColor: colorScheme.primary,
                    ),
                    onTap: () => controller.changeTheme(ThemeMode.system),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ─── Información adicional ─────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Información',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• El tema se aplica inmediatamente en toda la aplicación\n'
                      '• Tu preferencia se guarda automáticamente\n'
                      '• El modo automático cambia según la hora del día en tu dispositivo',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Estado actual ─────────────────────────────
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema Actual',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.currentThemeName,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
