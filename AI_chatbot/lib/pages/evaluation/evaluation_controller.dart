import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvaluationController extends GetxController {
  // Controladores para el campo de comentario
  TextEditingController commentController = TextEditingController();

  // Índice de la razón seleccionada (-1 = ninguna)
  RxInt selectedReasonIndex = (-1).obs;

  // Mensaje de validación / confirmación
  RxString message = ''.obs;

  // Color del mensaje (por defecto, rojo para errores)
  Rx<MaterialColor> messageColor = Colors.red.obs;

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// Llama a esta función al presionar el botón “ENVIAR”
  Future<void> submitEvaluation(BuildContext context) async {
    // Validar que hayan seleccionado una razón
    if (selectedReasonIndex.value < 0) {
      message.value = 'Por favor, selecciona una razón.';
      messageColor.value = Colors.red;
      return;
    }

    // Obtener el texto del comentario (puede estar vacío)
    final commentText = commentController.text.trim();

    // Simular envío a un servicio (por ejemplo, llamar a un API REST, base de datos local, etc.)
    // Aquí solo haremos una pequeña demora para simular una petición asíncrona.
    try {
      // Limpiar mensaje previo
      message.value = '';
      
      // Simulación de espera (por ejemplo, llamada HTTP)
      await Future.delayed(const Duration(seconds: 1));

      // Si se envió correctamente, mostramos mensaje de éxito
      message.value = '¡Evaluación enviada correctamente!';
      messageColor.value = Colors.green;

      // Opcional: Limpiar campos después del envío
      selectedReasonIndex.value = -1;
      commentController.clear();

      // (Opcional) Si quieres redirigir o hacer algo más después de un tiempo
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.pushReplacementNamed(context, '/otraRuta');
      // });
    } catch (e) {
      // En caso de error al enviar
      message.value = 'Error al enviar: ${e.toString()}';
      messageColor.value = Colors.red;
    }
  }

  /// Lógica para actualizar la razón seleccionada desde la UI
  void setReasonIndex(int index) {
    selectedReasonIndex.value = index;
  }
}
