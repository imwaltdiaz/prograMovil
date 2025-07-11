// lib/pages/login/login_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../configs/api_config.dart';

class LoginController extends GetxController {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final AuthService _authService = AuthService();

  RxString message = ''.obs;
  Rx<Color> messageColor = Colors.red.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // En modo debug, precargar credenciales de prueba
    if (kDebugMode) {
      txtUser.text = 'usuario1@example.com';
      txtPassword.text = 'password123';
    }
  }

  Future<void> login() async {
    String email = txtUser.text.trim();
    String password = txtPassword.text.trim();

    // Validaciones básicas
    if (email.isEmpty || password.isEmpty) {
      message.value = 'Por favor ingresa email y contraseña';
      messageColor.value = Colors.red;
      return;
    }

    // Validar formato de email
    if (!GetUtils.isEmail(email)) {
      message.value = 'Por favor ingresa un email válido';
      messageColor.value = Colors.red;
      return;
    }

    isLoading.value = true;
    message.value = 'Iniciando sesión...';
    messageColor.value = Colors.blue;

    try {
      final response = await _authService.login(email, password);

      if (response.success && response.data != null) {
        message.value = 'Login exitoso';
        messageColor.value = Colors.green;

        // Navegar directamente al chat
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offNamed('/chat', arguments: {
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
          message.value = response.error ?? 'Error de autenticación';
        }
        messageColor.value = Colors.red;
      }
    } catch (e) {
      message.value = 'Error de conexión: $e';
      messageColor.value = Colors.red;
      print('Error en login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  String getApiUrl() {
    return ApiConfig.fullBaseUrl;
  }

  @override
  void onClose() {
    txtUser.dispose();
    txtPassword.dispose();
    super.onClose();
  }
}
