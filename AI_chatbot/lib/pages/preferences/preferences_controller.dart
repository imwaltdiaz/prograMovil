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

  /// Lista de modelos IA disponibles
  var modelosIA = <ModeloIA>[].obs;

  /// Modelo IA actualmente seleccionado como preferido
  Rx<ModeloIA?> modeloSeleccionado = Rxn<ModeloIA>();

  /// Mensaje de éxito/error
  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;

  /// Estado de tema claro/oscuro
  RxBool isDarkMode = false.obs;

  /// Estado de notificaciones
  RxBool mensajesNuevos = true.obs;
  RxBool actualizaciones = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _cargarModelosIA();
      _cargarPreferenciaUsuario();
    } else {
      Get.back();
    }
  }

  Future<void> _cargarModelosIA() async {
    final lista = await modeloIAService.getTodosModelosIA();
    modelosIA.assignAll(lista);
  }

  Future<void> _cargarPreferenciaUsuario() async {
    final PreferenciaUsuario? pref =
        await preferenciaService.getPreferenciaPorUsuario(user.usuario_id);
    if (pref != null) {
      final seleccionado = modelosIA.firstWhereOrNull(
        (m) => m.modelo_ia_id == pref.modelo_ia_default_id,
      );
      modeloSeleccionado.value = seleccionado;
    }
  }

  Future<void> guardarPreferencia() async {
    // Por ahora este método solo muestra un mensaje de que se guardaron cambios
    message.value = 'Cambios guardados (demo)';
    messageColor.value = Colors.green;

    Future.delayed(const Duration(seconds: 3), () {
      message.value = '';
    });
  }

  void goToHistory() {
    Get.toNamed('/history', arguments: user);
  }

  void goToProfile() {
    Get.toNamed('/profile', arguments: user);
  }

  void goToAIConfig() {
    Get.toNamed('/configuracionAI', arguments: user);
  }

  void goToThemeSettings() {
    Get.toNamed('/theme-settings');
  }

  void goToPrivacy() {
    Get.toNamed('/privacidad', arguments: user);
  }
}
