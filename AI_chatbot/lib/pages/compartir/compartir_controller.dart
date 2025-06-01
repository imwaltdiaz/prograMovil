// lib/pages/compartir/compartir_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompartirController extends GetxController {
  /// 0 = Texto plano, 1 = Imagen, 2 = Enlace (próx.)
  RxInt selectedFormat = 1.obs;

  /// Incluir preguntas
  RxBool includePreguntas = true.obs;

  /// Incluir respuestas
  RxBool includeRespuestas = true.obs;

  /// Mensaje que se mostrará tras intentar compartir
  RxString message = ''.obs;

  /// Color del mensaje (por defecto rojo para errores, verde para éxito)
  Rx<MaterialColor> messageColor = Colors.red.obs;

  /// Actualiza el formato seleccionado (texto plano, imagen o enlace)
  void setFormat(int formatIndex) {
    selectedFormat.value = formatIndex;
  }

  /// Marca si incluir preguntas
  void toggleIncludePreguntas(bool value) {
    includePreguntas.value = value;
  }

  /// Marca si incluir respuestas
  void toggleIncludeRespuestas(bool value) {
    includeRespuestas.value = value;
  }

  /// Lógica para compartir la conversación
  ///
  /// Aquí simularemos un envío o generación de la conversación en el formato
  /// escogido (_selectedFormat) y con las opciones de incluirPreguntas /
  /// incluirRespuestas. En un caso real, podrías:
  ///  - Generar un archivo PDF o texto
  ///  - Crear una imagen (screenshot) de la conversación
  ///  - Obtener un enlace desde tu backend
  ///  - Invocar un plugin de “share” para distribuir por apps sociales
  Future<void> shareConversation(BuildContext context) async {
    // Validar que al menos una de las dos casillas esté marcada
    if (!includePreguntas.value && !includeRespuestas.value) {
      message.value = 'Debes incluir preguntas o respuestas para compartir.';
      messageColor.value = Colors.red;
      return;
    }

    try {
      // Limpiar mensaje previo
      message.value = '';

      // Simular procesamiento asíncrono (p. ej. compilación de la conversación)
      await Future.delayed(const Duration(seconds: 1));

      // Dependiendo de selectedFormat, podrías distinguir lógicas:
      // if (selectedFormat.value == 0) { /* texto plano */ }
      // else if (selectedFormat.value == 1) { /* imagen */ }
      // else { /* enlace */ }

      // Para este ejemplo, asumimos que todo salió bien:
      message.value = 'Conversación compartida correctamente.';
      messageColor.value = Colors.green;

      // (Opcional) Limpiar estado tras compartir
      // selectedFormat.value = 1;
      // includePreguntas.value = true;
      // includeRespuestas.value = true;
    } catch (e) {
      message.value = 'Error al compartir: ${e.toString()}';
      messageColor.value = Colors.red;
    }

    // Mostrar un SnackBar con el resultado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.value,
          style: TextStyle(color: messageColor.value),
        ),
        backgroundColor: messageColor.value.withOpacity(0.1),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
