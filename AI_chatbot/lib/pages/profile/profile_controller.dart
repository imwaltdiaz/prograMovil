// lib/pages/profile/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();

  late final Usuario user;

  // Controladores para los campos editables
  late final TextEditingController txtName;
  late final TextEditingController txtEmail;
  late final TextEditingController txtPhone; // si agregas teléfono más tarde
  RxString fechaRegistroValue = ''.obs; // Para mostrar la fecha de registro

  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      txtName = TextEditingController(text: user.nombre);
      txtEmail = TextEditingController(text: user.email);
      // txtPhone = TextEditingController(text: user.telefono ?? '');

      // Formateamos fecha_registro a “YYYY-MM-DD”
      final d = user.fecha_registro.toLocal();
      fechaRegistroValue.value =
          '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    } else {
      Get.back();
    }
  }

  /// Cuando el usuario pulsa “Guardar cambios”
  Future<void> saveProfile() async {
    final nuevoNombre = txtName.text.trim();
    final nuevoEmail = txtEmail.text.trim();

    if (nuevoNombre.isEmpty || nuevoEmail.isEmpty) {
      message.value = 'Nombre y correo no pueden ir vacíos';
      messageColor.value = Colors.red;
      return;
    }

    isLoading.value = true;
    message.value = '';

    // Actualizamos localmente el objeto user y luego persistimos
    try {
      // Llamar al backend para actualizar el perfil
      final response = await _userService.updateProfile(
        nombre: nuevoNombre,
        email: nuevoEmail,
      );

      if (response.success && response.data != null) {
        // Actualizar el objeto user local con los datos del backend
        user.nombre = response.data!.nombre;
        user.email = response.data!.email;

        message.value = 'Perfil actualizado exitosamente';
        messageColor.value = Colors.green;
      } else {
        message.value = response.error ?? 'Error al actualizar perfil';
        messageColor.value = Colors.red;
      }
    } catch (e) {
      message.value = 'Error de conexión: $e';
      messageColor.value = Colors.red;
    } finally {
      isLoading.value = false;
    }
  }

  void goToPreferences() {
    Get.offNamed('/preferences', arguments: user);
  }

  /// Navegar a la página de cambio de contraseña
  void goToChangePassword() {
    Get.toNamed('/change-password');
  }

  @override
  void onClose() {
    txtName.dispose();
    txtEmail.dispose();
    // txtPhone?.dispose();
    super.onClose();
  }
}
