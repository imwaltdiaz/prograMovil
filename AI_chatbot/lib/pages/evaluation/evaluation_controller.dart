// lib/pages/evaluation/evaluation_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvaluationController extends GetxController {
  /// Controlador para el TextField del comentario
  final TextEditingController commentController = TextEditingController();

  /// Índice de la razón seleccionada (-1 = ninguna)
  final RxInt selectedReasonIndex = (-1).obs;

  /// Mensaje de validación o confirmación
  final RxString message = ''.obs;

  /// Color del texto del mensaje
  final Rx<MaterialColor> messageColor = Colors.red.obs;

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// Se invoca al presionar “ENVIAR”
  Future<void> submitEvaluation(BuildContext context) async {
    // 1) Validar que haya seleccionado una razón
    if (selectedReasonIndex.value < 0) {
      message.value = 'Por favor, selecciona una razón.';
      messageColor.value = Colors.red;
      return;
    }

    // 2) Tomamos el texto del comentario (opcional)
    final commentText = commentController.text.trim();

    // 3) Simular llamada a servicio (p.ej. HTTP, DB local, etc.)
    try {
      // Limpiamos mensaje previo
      message.value = '';

      // Simulación de demora / petición real
      await Future.delayed(const Duration(seconds: 1));

      // Si todo sale bien:
      message.value = '¡Evaluación enviada correctamente!';
      messageColor.value = Colors.green;

      // 4) Limpiar campos
      selectedReasonIndex.value = -1;
      commentController.clear();

      // (Opcional) Redirigir o cerrar pantalla luego de unos segundos
      // Future.delayed(const Duration(seconds: 2), () {
      //   Get.back();
      // });
    } catch (e) {
      message.value = 'Error al enviar: ${e.toString()}';
      messageColor.value = Colors.red;
    }
  }

  /// Actualizar la razón seleccionada
  void setReasonIndex(int index) {
    selectedReasonIndex.value = index;
  }
}
