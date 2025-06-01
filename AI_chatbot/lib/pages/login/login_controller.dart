import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/login_service.dart';

class LoginController extends GetxController {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;
  final LoginService loginService = LoginService(); // Instancia del servicio

  Future<void> login(BuildContext context) async {
    bool isValid = await loginService.validateUser(
      txtUser.text,
      txtPassword.text,
    );

    print("Validación completada: $isValid");

    if (isValid) {
      message.value = "¡Usuario válido!";
      messageColor.value = Colors.green;
      Navigator.pushReplacementNamed(context, '/chat'); // Redirige
    } else {
      message.value = "Usuario o contraseña incorrectos";
      messageColor.value = Colors.red;
    }
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }
}
