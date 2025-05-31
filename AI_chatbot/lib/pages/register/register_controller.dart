import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/register_service.dart';

class RegisterController extends GetxController {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;
  final RegisterService registerService = RegisterService();

  Future<void> register(BuildContext context) async {
    if (txtEmail.text.isEmpty || txtPassword.text.isEmpty) {
      message.value = "Email y contraseña son requeridos";
      messageColor.value = Colors.red;
      return;
    }

    try {
      await registerService.registerUser(txtEmail.text, txtPassword.text);

      message.value = "¡Registro exitoso!";
      messageColor.value = Colors.green;

      // Limpiar campos después del registro
      txtEmail.clear();
      txtPassword.clear();

      // Redirigir después de 2 segundos
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } catch (e) {
      message.value = "Error: ${e.toString()}";
      messageColor.value = Colors.red;
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void goToPreferences(BuildContext context) {
    Navigator.pushNamed(context, '/preferences');
  }
}
