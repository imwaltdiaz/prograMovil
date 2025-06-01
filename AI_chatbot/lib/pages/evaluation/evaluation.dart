// lib/pages/evaluation/evaluation.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'evaluation_controller.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tomamos el theme actual
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Instanciamos el controller de GetX
    final EvaluationController controller = Get.put(EvaluationController());

    // Lista de razones (podría venir del controller, pero la dejamos aquí como constante)
    const List<String> reasons = [
      'Incorrecta',
      'Incompleta',
      'No entendió',
      'Otra razón'
    ];

    return Scaffold(
      // Usamos el background definido en el theme (puede ser background o surface según tu preferencia)
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        title: Text(
          'Evaluar respuestas',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ======= Tarjeta con la "respuesta del chatbot" =======
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Para la tarjeta, usamos el color de surface con sombra
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // Usamos la sombra con la opacidad baja del onSurface
                      color: colorScheme.onSurface.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluación de respuesta',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'La respuesta del chatbot contiene información precisa sobre el tema solicitado, con detalles y ejemplos.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Ícono de “bien” (pulgar arriba, verde)
                        IconButton(
                          onPressed: () {
                            // Lógica opcional para marcar "thumb up"
                            // Ejemplo: controller.markThumbUp();
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            color: colorScheme.primary, // color principal
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Ícono de “mal” (pulgar abajo, rojo)
                        IconButton(
                          onPressed: () {
                            // Lógica opcional para marcar "thumb down"
                            // Ejemplo: controller.markThumbDown();
                          },
                          icon: Icon(
                            Icons.thumb_down,
                            color: colorScheme.error, // color de error
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ======= Pregunta "¿Por qué no fue útil?" =======
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Por qué no fue útil?',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Construimos cada opción con RadioListTile dentro de Obx para reactividad
                    ...List.generate(reasons.length, (index) {
                      return Obx(() {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.onSurface.withOpacity(0.03),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: RadioListTile<int>(
                            value: index,
                            groupValue: controller.selectedReasonIndex.value,
                            title: Text(
                              reasons[index],
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            activeColor: colorScheme.primary,
                            onChanged: (value) {
                              controller.setReasonIndex(value!);
                            },
                          ),
                        );
                      });
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ======= Campo de comentario =======
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Comentario...',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.onSurface.withOpacity(0.03),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Escribe un comentario...',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ======= Mensaje de validación o confirmación =======
              Obx(() {
                if (controller.message.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 16),
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

              // ======= Botón ENVIAR =======
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => controller.submitEvaluation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ENVIAR',
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
