// lib/pages/share/share_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'share_controller.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controller
    final ShareController controller = Get.put(ShareController());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Compartir conversación',
          style: textTheme.titleLarge?.copyWith(
            color:
                colorScheme.onSurface, // Reemplazado onBackground por onSurface
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
              // ─── Sección: “Seleccionar formato” ─────────────────────
              Text(
                'Seleccionar formato:',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface, // Reemplazado onBackground
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Column(
                  children: [
                    // Texto plano
                    RadioListTile<int>(
                      value: 0,
                      groupValue: controller.selectedFormatIndex.value,
                      title: Text(
                        'Texto plano',
                        style: textTheme.bodyLarge?.copyWith(
                          color:
                              colorScheme.onSurface, // Reemplazado onBackground
                        ),
                      ),
                      activeColor: colorScheme.primary,
                      // onChanged ahora acepta int?
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          controller.setFormat(newValue);
                        }
                      },
                    ),

                    // Imagen
                    RadioListTile<int>(
                      value: 1,
                      groupValue: controller.selectedFormatIndex.value,
                      title: Text(
                        'Imagen',
                        style: textTheme.bodyLarge?.copyWith(
                          color:
                              colorScheme.onSurface, // Reemplazado onBackground
                        ),
                      ),
                      activeColor: colorScheme.primary,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          controller.setFormat(newValue);
                        }
                      },
                    ),

                    // Enlace (deshabilitado por el momento)
                    RadioListTile<int>(
                      value: 2,
                      groupValue: controller.selectedFormatIndex.value,
                      title: Text(
                        'Enlace (próx.)',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface
                              .withOpacity(0.4), // Reemplazado onBackground
                        ),
                      ),
                      activeColor: colorScheme.primary.withOpacity(0.4),
                      onChanged: null, // Deshabilitado
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ─── Sección: “Incluir” ───────────────────────────────────
              Text(
                'Incluir:',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface, // Reemplazado onBackground
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Column(
                  children: [
                    // Checkbox Preguntas
                    CheckboxListTile(
                      value: controller.includeQuestions.value,
                      onChanged: controller.toggleIncludeQuestions,
                      title: Text(
                        'Preguntas',
                        style: textTheme.bodyLarge?.copyWith(
                          color:
                              colorScheme.onSurface, // Reemplazado onBackground
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Checkbox Respuestas
                    CheckboxListTile(
                      value: controller.includeAnswers.value,
                      onChanged: controller.toggleIncludeAnswers,
                      title: Text(
                        'Respuestas',
                        style: textTheme.bodyLarge?.copyWith(
                          color:
                              colorScheme.onSurface, // Reemplazado onBackground
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ─── Vista previa (contenedor con sombra) ────────────────
              Text(
                'Vista previa de la conversación:',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface, // Reemplazado onBackground
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.onSurface
                            .withOpacity(0.05), // Reemplazado onBackground
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    controller.previewText,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface
                          .withOpacity(0.7), // Reemplazado onBackground
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // ─── Mensaje de feedback (error / éxito) ─────────────────
              Obx(() {
                if (controller.feedbackMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: controller.feedbackColor.value.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.feedbackMessage.value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: controller.feedbackColor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),

              // ─── Botón “COMPARTIR” ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => controller.shareConversation(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'COMPARTIR',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
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
