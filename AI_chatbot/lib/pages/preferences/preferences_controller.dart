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

  /// Lista de modelos IA disponibles (por si quisieras mostrar algo aquí)
  var modelosIA = <ModeloIA>[].obs;

  /// Modelo IA actualmente seleccionado como preferido
  Rx<ModeloIA?> modeloSeleccionado = Rxn<ModeloIA>();

  /// Mensaje de éxito/error para mostrar en la pantalla
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

  /// Carga todos los modelos IA activos en memoria
  Future<void> _cargarModelosIA() async {
    final lista = await modeloIAService.getTodosModelosIA();
    modelosIA.assignAll(lista);
  }

  /// Consulta la preferencia del usuario actual (su modelo IA por defecto)
  Future<void> _cargarPreferenciaUsuario() async {
    final PreferenciaUsuario? pref =
        await preferenciaService.getPreferenciaPorUsuario(user.usuario_id);
    if (pref != null) {
      // Buscamos el objeto ModeloIA en la colección para asignarlo
      final seleccionado = modelosIA.firstWhereOrNull(
        (m) => m.modelo_ia_id == pref.modelo_ia_default_id,
      );
      modeloSeleccionado.value = seleccionado;
    }
  }

  /// Guarda en JSON la preferencia de modelo IA del usuario
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

    // Limpiar mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      message.value = '';
    });
  }

  /// Navegar a Historial de chat
  void goToHistory() {
    Get.toNamed('/history', arguments: user);
  }

  /// Navegar a Editar Perfil
  void goToProfile() {
    Get.toNamed('/profile', arguments: user);
  }

  /// Navegar a Configuración de IA
  void goToAIConfig() {
    Get.toNamed('/configuracionAI', arguments: user);
  }
}
