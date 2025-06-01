// lib/pages/evaluation/evaluation.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'evaluation_controller.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xFFFDF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF5F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Evaluar respuestas',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
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
                  color: const Color(0xFFFFF1F3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Evaluación de respuesta',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'La respuesta del chatbot contiene información precisa sobre el tema solicitado, con detalles y ejemplos.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: Colors.black54,
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
                            // Por ejemplo: controller.markThumbUp();
                          },
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Ícono de “mal” (pulgar abajo, rojo)
                        IconButton(
                          onPressed: () {
                            // Lógica opcional para marcar "thumb down"
                            // Por ejemplo: controller.markThumbDown();
                          },
                          icon: const Icon(
                            Icons.thumb_down,
                            color: Colors.red,
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
                    const Text(
                      '¿Por qué no fue útil?',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Construimos cada opción con RadioListTile dentro de Obx para reactividad
                    ...List.generate(reasons.length, (index) {
                      return Obx(() {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
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
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            activeColor: Colors.blueAccent,
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
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un comentario...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
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
                    style: TextStyle(
                      color: controller.messageColor.value,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ENVIAR',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
