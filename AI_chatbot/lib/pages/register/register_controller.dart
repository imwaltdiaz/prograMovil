import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/register_service.dart';
import '../../services/usuario_service.dart';
import '../../models/user.dart';

class RegisterController extends GetxController {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final RegisterService registerService = RegisterService();
  final UsuarioService usuarioService = UsuarioService();

  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;

  Future<void> register() async {
    final email = txtEmail.text.trim();
    final nombre = txtName.text.trim();
    final password = txtPassword.text.trim();

    if (email.isEmpty || nombre.isEmpty || password.isEmpty) {
      message.value = 'Todos los campos son obligatorios';
      messageColor.value = Colors.red;
      return;
    }

    // Llamo a registerUser con parámetros nombrados y recibo un bool
    final bool registrado = await registerService.registerUser(
      email: email,
      nombre: nombre,
      password: password,
    );

    if (!registrado) {
      // Si devuelve false, significa que ya había un usuario con ese email
      message.value = 'El correo ya está registrado';
      messageColor.value = Colors.red;
      return;
    }

    // Si llegamos aquí, el registro (mock) fue exitoso
    final Usuario? usuario = await usuarioService.getUsuarioPorEmail(email);
    if (usuario == null) {
      message.value = 'Registrado, pero no se pudo cargar perfil';
      messageColor.value = Colors.red;
      return;
    }

    // Navegar a preferencias, pasando el objeto Usuario
    Get.offNamed(
      '/preferences',
      arguments: usuario,
    );
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  @override
  void onClose() {
    txtEmail.dispose();
    txtName.dispose();
    txtPassword.dispose();
    super.onClose();
  }
}
