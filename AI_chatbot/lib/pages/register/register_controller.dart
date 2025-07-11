import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class RegisterController extends GetxController {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final AuthService _authService = AuthService();

  RxString message = ''.obs;
  Rx<Color> messageColor = Colors.red.obs;
  RxBool isLoading = false.obs;

  Future<void> register() async {
    String name = txtName.text.trim();
    String email = txtEmail.text.trim();
    String password = txtPassword.text.trim();

    // Validaciones básicas
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      message.value = 'Todos los campos son obligatorios';
      messageColor.value = Colors.red;
      return;
    }

    // Validar formato de email
    if (!GetUtils.isEmail(email)) {
      message.value = 'Por favor ingresa un email válido';
      messageColor.value = Colors.red;
      return;
    }

    // Validar longitud de contraseña
    if (password.length < 6) {
      message.value = 'La contraseña debe tener al menos 6 caracteres';
      messageColor.value = Colors.red;
      return;
    }

    isLoading.value = true;
    message.value = 'Registrando usuario...';
    messageColor.value = Colors.blue;

    try {
      final response = await _authService.register(name, email, password);

      if (response.success && response.data != null) {
        message.value = 'Registro exitoso';
        messageColor.value = Colors.green;

        // Navegar al historial
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offNamed('/history', arguments: {
          'user': response.data,
        });
      } else {
        // Mostrar errores de validación si existen
        if (response.validationErrors != null &&
            response.validationErrors!.isNotEmpty) {
          final errors = response.validationErrors!
              .map((e) => '${e.field}: ${e.message}')
              .join('\n');
          message.value = errors;
        } else {
          message.value = response.error ?? 'Error en el registro';
        }
        messageColor.value = Colors.red;
      }
    } catch (e) {
      message.value = 'Error de conexión: $e';
      messageColor.value = Colors.red;
      print('Error en registro: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back(); // Volver al login
  }

  @override
  void onClose() {
    txtEmail.dispose();
    txtName.dispose();
    txtPassword.dispose();
    super.onClose();
  }
}
