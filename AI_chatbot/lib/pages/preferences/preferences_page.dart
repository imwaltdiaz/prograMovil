// lib/pages/preferences/preferences_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'preferences_controller.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferencesController controller = Get.put(PreferencesController());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Preferencias',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Historial de chat ────────────────────────────────
            GestureDetector(
              onTap: () {
                controller.goToHistory();
              },
              child: Row(
                children: [
                  Icon(Icons.history, color: colorScheme.onBackground),
                  const SizedBox(width: 8),
                  Text(
                    'Historial de chat',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── Editar información ────────────────────────────────
            GestureDetector(
              onTap: () {
                controller.goToProfile();
              },
              child: Row(
                children: [
                  Icon(Icons.person, color: colorScheme.onBackground),
                  const SizedBox(width: 8),
                  Text(
                    'Editar información',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ─── Selección de modelo IA ────────────────────────────
            Text(
              'Modelo de IA predeterminado',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Selecciona un modelo',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'gpt-4', child: Text('gpt-4')),
                DropdownMenuItem(value: 'gpt-3.5', child: Text('gpt-3.5')),
                // …otros modelos
              ],
              onChanged: (value) {
                // Por ejemplo:
                // final seleccionado = controller.modelosIA.firstWhere((m) => m.identificador_interno_modelo == value);
                // controller.modeloSeleccionado.value = seleccionado;
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  controller.guardarPreferencia();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Guardar cambios',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() {
              if (controller.message.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: controller.messageColor.value.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.message.value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: controller.messageColor.value,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
