// lib/pages/share/share_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareController extends GetxController {
  /// Formatos posibles para compartir
  /// 0 = Texto plano
  /// 1 = Imagen
  /// 2 = Enlace (por el momento deshabilitado)
  var selectedFormatIndex = 1.obs;

  /// Incluir preguntas
  var includeQuestions = true.obs;

  /// Incluir respuestas
  var includeAnswers = true.obs;

  /// Mensaje de feedback (por ejemplo, "Compartido con éxito" o errores)
  RxString feedbackMessage = ''.obs;

  /// Color del feedback (verde al éxito, rojo al error)
  Rx<MaterialColor> feedbackColor = Colors.green.obs;

  /// Simula el texto que aparecerá en la vista previa
  String get previewText {
    final parts = <String>[];
    if (includeQuestions.value) parts.add("[Preguntas incluidas]");
    if (includeAnswers.value) parts.add("[Respuestas incluidas]");
    if (parts.isEmpty) {
      return "Selecciona al menos 'Preguntas' o 'Respuestas' para generar la vista previa.";
    }
    // En una implementación real, aquí pegarías el contenido de la conversación filtrado.
    return parts.join(" + ") + "\n\n[Vista previa de la conversación aquí]";
  }

  /// Llamar cuando se presiona "COMPARTIR"
  Future<void> shareConversation() async {
    // Validaciones básicas:
    if (!includeQuestions.value && !includeAnswers.value) {
      feedbackMessage.value = 'Debes incluir preguntas, respuestas o ambas.';
      feedbackColor.value = Colors.red;
      return;
    }
    // Simular un retardo de "envío"
    try {
      feedbackMessage.value = ''; // limpiar feedback anterior
      await Future.delayed(const Duration(milliseconds: 800));

      // En un caso real, aquí invocarías el plugin de compartir o la lógica que genere el PDF/imagen, etc.
      feedbackMessage.value = '¡Conversación compartida con éxito!';
      feedbackColor.value = Colors.green;
    } catch (e) {
      feedbackMessage.value = 'Error al compartir: ${e.toString()}';
      feedbackColor.value = Colors.red;
    }
  }

  /// Actualizar el formato seleccionado
  void setFormat(int index) {
    selectedFormatIndex.value = index;
  }

  /// Cambiar incluir Preguntas
  void toggleIncludeQuestions(bool? value) {
    if (value == null) return;
    includeQuestions.value = value;
  }

  /// Cambiar incluir Respuestas
  void toggleIncludeAnswers(bool? value) {
    if (value == null) return;
    includeAnswers.value = value;
  }
}
