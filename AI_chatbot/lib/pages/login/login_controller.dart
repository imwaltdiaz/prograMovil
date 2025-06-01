// lib/pages/login/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/login_service.dart';
import '../../services/usuario_service.dart';
import '../../models/user.dart';
import '../../models/conversacion.dart';

class LoginController extends GetxController {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final LoginService loginService = LoginService();
  final UsuarioService usuarioService = UsuarioService();

  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;

  Future<void> login() async {
    String email = txtUser.text.trim();
    String password = txtPassword.text.trim();

    bool isValid = await loginService.validateUser(email, password);
    if (!isValid) {
      message.value = 'Usuario o contraseña incorrectos';
      messageColor.value = Colors.red;
      return;
    }

    Usuario? usuario = await usuarioService.getUsuarioPorEmail(email);
    if (usuario == null) {
      message.value = 'No se encontró el perfil para ese usuario';
      messageColor.value = Colors.red;
      return;
    }

    // Creamos una conversación nueva (o la que necesites)
    final Conversacion nuevaConversacion = Conversacion(
      conversacion_id: DateTime.now().millisecondsSinceEpoch,
      usuario_id: usuario.usuario_id,
      modelo_ia_id: 1,
      titulo: 'Nueva conversación',
      fecha_creacion: DateTime.now().toUtc(),
      ultima_actualizacion: DateTime.now().toUtc(),
    );

    // Navegar a ChatPage sin usar 'context'
    Get.offNamed(
      '/chat',
      arguments: {
        'user': usuario,
        'conversacion': nuevaConversacion,
      },
    );
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    txtUser.dispose();
    txtPassword.dispose();
    super.onClose();
  }
}
