// lib/pages/preferences/preferences_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user.dart';
import '../../models/preferencia_usuario.dart';
import '../../models/modelo_ia.dart';
import '../../services/usuario_service.dart';
import '../../services/preferencia_usuario_service.dart';
import '../../services/modelo_ia_service.dart';

class PreferencesController extends GetxController {
  final UsuarioService usuarioService = UsuarioService();
  final PreferenciaService preferenciaService = PreferenciaService();
  final ModeloIAService modeloIAService = ModeloIAService();

  /// El usuario que vino en los argumentos de la ruta:
  late final Usuario user;

  /// Lista de modelos IA disponibles:
  var modelosIA = <ModeloIA>[].obs;

  /// Modelo IA seleccionado:
  Rx<ModeloIA?> modeloSeleccionado = Rx<ModeloIA?>(null);

  /// Para mostrar mensaje de éxito/error:
  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;

  @override
  void onInit() {
    super.onInit();
    // 1) Leer los argumentos que nos pasó Get.toNamed('/preferences', arguments: usuario)
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _cargarModelosIA();
      _cargarPreferenciaUsuario();
    } else {
      // Si no recibimos un Usuario válido, simplemente volvemos atrás
      Get.back();
    }
  }

  /// Carga todos los modelos IA activos para la lista de selección
  Future<void> _cargarModelosIA() async {
    final lista = await modeloIAService.getTodosModelosIA();
    modelosIA.assignAll(lista);
  }

  /// Consulta la preferencia del usuario actual (su modelo IA por defecto)
  Future<void> _cargarPreferenciaUsuario() async {
    final PreferenciaUsuario? pref =
        await preferenciaService.getPreferenciaPorUsuario(user.usuario_id);
    if (pref != null) {
      // Buscamos el objeto ModeloIA en la colección para asignarlo al Rx
      final seleccionado = modelosIA.firstWhereOrNull(
        (m) => m.modelo_ia_id == pref.modelo_ia_default_id,
      );
      modeloSeleccionado.value = seleccionado;
    }
  }

  /// Cuando el usuario selecciona un nuevo modelo de la lista, lo guardamos:
  Future<void> guardarPreferencia() async {
    final seleccion = modeloSeleccionado.value;
    if (seleccion == null) {
      message.value = 'Debes elegir un modelo de IA.';
      messageColor.value = Colors.red;
      return;
    }

    final bool exito = await preferenciaService.guardarPreferenciaUsuario(
      user.usuario_id,
      seleccion.modelo_ia_id,
    );

    if (exito) {
      message.value = 'Preferencia guardada';
      messageColor.value = Colors.green;
    } else {
      message.value = 'Error al guardar preferencia';
      messageColor.value = Colors.red;
    }
  }

  /// Navegar a Historial
  void goToHistory() {
    Get.toNamed('/history', arguments: user);
  }

  /// Navegar a Editar Perfil
  void goToProfile() {
    Get.toNamed('/profile', arguments: user);
  }
}
