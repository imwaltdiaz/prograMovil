// lib/pages/change_password/change_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/user_service.dart';

class ChangePasswordController extends GetxController {
  final UserService _userService = UserService();

  // Controladores de texto
  late final TextEditingController txtCurrentPassword;
  late final TextEditingController txtNewPassword;
  late final TextEditingController txtConfirmPassword;

  // Estados observables
  RxBool isLoading = false.obs;
  RxBool showCurrentPassword = false.obs;
  RxBool showNewPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxString message = ''.obs;
  Rx<Color> messageColor = Colors.red.obs;

  @override
  void onInit() {
    super.onInit();
    txtCurrentPassword = TextEditingController();
    txtNewPassword = TextEditingController();
    txtConfirmPassword = TextEditingController();
  }

  @override
  void onClose() {
    txtCurrentPassword.dispose();
    txtNewPassword.dispose();
    txtConfirmPassword.dispose();
    super.onClose();
  }

  void clearMessage() {
    message.value = '';
  }

  void showError(String errorMessage) {
    message.value = errorMessage;
    messageColor.value = Colors.red;
  }

  void showSuccess(String successMessage) {
    message.value = successMessage;
    messageColor.value = Colors.green;
  }

  bool _validateInputs() {
    clearMessage();

    if (txtCurrentPassword.text.trim().isEmpty) {
      showError('Por favor ingresa tu contraseña actual');
      return false;
    }

    if (txtNewPassword.text.trim().isEmpty) {
      showError('Por favor ingresa tu nueva contraseña');
      return false;
    }

    if (txtNewPassword.text.trim().length < 6) {
      showError('La nueva contraseña debe tener al menos 6 caracteres');
      return false;
    }

    if (txtConfirmPassword.text.trim().isEmpty) {
      showError('Por favor confirma tu nueva contraseña');
      return false;
    }

    if (txtNewPassword.text.trim() != txtConfirmPassword.text.trim()) {
      showError('Las contraseñas no coinciden');
      return false;
    }

    if (txtCurrentPassword.text.trim() == txtNewPassword.text.trim()) {
      showError('La nueva contraseña debe ser diferente a la actual');
      return false;
    }

    return true;
  }

  Future<void> changePassword() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    clearMessage();

    try {
      final result = await _userService.changePassword(
        currentPassword: txtCurrentPassword.text.trim(),
        newPassword: txtNewPassword.text.trim(),
      );

      if (result.success) {
        showSuccess(result.data ?? 'Contraseña cambiada exitosamente');

        // Limpiar campos después de éxito
        txtCurrentPassword.clear();
        txtNewPassword.clear();
        txtConfirmPassword.clear();

        // Opcional: volver a la página anterior después de un delay
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isRegistered<ChangePasswordController>()) {
            Get.back();
          }
        });
      } else {
        showError(result.error ?? result.message);
      }
    } catch (e) {
      print('Error en changePassword: $e');
      showError('Error de conexión. Verifica tu conexión a internet.');
    } finally {
      isLoading.value = false;
    }
  }
}
