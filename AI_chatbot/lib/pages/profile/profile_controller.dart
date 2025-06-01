// lib/pages/profile/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user.dart';
import '../../services/usuario_service.dart';

class ProfileController extends GetxController {
  final UsuarioService usuarioService = UsuarioService();

  late final Usuario user;

  // Controladores para los campos editables
  late final TextEditingController txtName;
  late final TextEditingController txtEmail;
  late final TextEditingController txtPhone; // si agregas teléfono más tarde
  RxString fechaRegistroValue = ''.obs; // Para mostrar la fecha de registro

  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;

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

    // Actualizamos localmente el objeto user y luego persistimos
    user.nombre = nuevoNombre;
    user.email = nuevoEmail;
    // Si hubieras agregado teléfono: user.telefono = txtPhone.text.trim();

    final bool exito = await usuarioService.actualizarUsuario(user);

    if (exito) {
      message.value = 'Perfil actualizado';
      messageColor.value = Colors.green;
    } else {
      message.value = 'Error al actualizar';
      messageColor.value = Colors.red;
    }
  }

  void goToPreferences() {
    Get.offNamed('/preferences', arguments: user);
  }

  @override
  void onClose() {
    txtName.dispose();
    txtEmail.dispose();
    // txtPhone?.dispose();
    super.onClose();
  }
}
