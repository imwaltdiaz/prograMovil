import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Campos de ejemplo para el perfil
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPhone = TextEditingController();

  // Variables reactivas para mostrar mensajes u otras propiedades si se requiere
  var message = ''.obs;
  var messageColor = Colors.red.obs;

  @override
  void onInit() {
    super.onInit();
    // Si ya tienes un usuario logueado, aquí podrías cargar sus datos iniciales.
    // Por ejemplo, podrías simular que traes "Juan Pérez" y "juan@mail.com":
    txtName.text = 'Juan Pérez';
    txtEmail.text = 'juan@mail.com';
    txtPhone.text = '555-1234';
  }

  /// Guarda los cambios del perfil (simulado)
  Future<void> saveProfile(BuildContext context) async {
    final name = txtName.text.trim();
    final email = txtEmail.text.trim();
    final phone = txtPhone.text.trim();

    if (name.isEmpty || email.isEmpty) {
      message.value = 'Nombre y correo son requeridos';
      messageColor.value = Colors.red;
      Get.snackbar('Error', message.value,
          backgroundColor: messageColor.value.withOpacity(0.1),
          colorText: messageColor.value);
      return;
    }

    // Aquí iría la lógica real de guardado (API, base de datos, etc.)
    // Por ahora simulamos éxito:
    message.value = 'Perfil actualizado correctamente';
    messageColor.value = Colors.green;
    Get.snackbar('Éxito', message.value,
        backgroundColor: messageColor.value.withOpacity(0.1),
        colorText: messageColor.value);

    // Opcional: podrías navegar a otra pantalla o regresar:
    // Navigator.pop(context);
  }

  @override
  void onClose() {
    txtName.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    super.onClose();
  }
}
