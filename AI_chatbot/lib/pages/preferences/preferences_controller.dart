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

  // Nuevas variables para las preferencias expandidas
  final selectedTheme = 'dark'.obs; // 'light' o 'dark'
  final newMessagesNotifications = true.obs;
  final updatesNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1) Leer los argumentos que nos pasó Get.toNamed('/preferences', arguments: usuario)
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _cargarModelosIA();
      _cargarPreferenciaUsuario();
      _cargarPreferenciasAdicionales();
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

  /// Carga las preferencias adicionales del usuario
  Future<void> _cargarPreferenciasAdicionales() async {
    // Aquí puedes cargar las preferencias adicionales desde tu servicio
    // Por ejemplo, si tienes una tabla de configuraciones adicionales:
    // final config = await preferenciaService.getConfiguracionUsuario(user.usuario_id);
    // if (config != null) {
    //   selectedTheme.value = config.tema ?? 'dark';
    //   newMessagesNotifications.value = config.notificacionesMensajes ?? true;
    //   updatesNotifications.value = config.notificacionesActualizaciones ?? false;
    // }
  }

  /// Cuando el usuario selecciona un nuevo modelo de la lista, lo guardamos:
  Future<void> guardarPreferencia() async {
    final seleccion = modeloSeleccionado.value;
    if (seleccion == null) {
      message.value = 'Debes elegir un modelo de IA.';
      messageColor.value = Colors.red;
      return;
    }

    try {
      // Guardar preferencia del modelo IA
      final bool exitoModelo =
          await preferenciaService.guardarPreferenciaUsuario(
        user.usuario_id,
        seleccion.modelo_ia_id,
      );

      // Guardar preferencias adicionales
      final bool exitoAdicionales = await _guardarPreferenciasAdicionales();

      if (exitoModelo && exitoAdicionales) {
        message.value = 'Preferencias guardadas correctamente';
        messageColor.value = Colors.green;

        // Aplicar el cambio de tema si es necesario
        _aplicarCambioTema();
      } else {
        message.value = 'Error al guardar algunas preferencias';
        messageColor.value = Colors.orange;
      }
    } catch (e) {
      message.value = 'Error al guardar preferencias';
      messageColor.value = Colors.red;
    }

    // Limpiar el mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      message.value = '';
    });
  }

  /// Guarda las preferencias adicionales del usuario
  Future<bool> _guardarPreferenciasAdicionales() async {
    try {
      // Aquí implementarías el guardado de las preferencias adicionales
      // Esto podría ser en la misma tabla de preferencias o en una tabla separada
      // Por ejemplo:
      // return await preferenciaService.guardarConfiguracionUsuario(
      //   user.usuario_id,
      //   tema: selectedTheme.value,
      //   notificacionesMensajes: newMessagesNotifications.value,
      //   notificacionesActualizaciones: updatesNotifications.value,
      // );

      // Por ahora retornamos true como placeholder
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Aplica el cambio de tema inmediatamente
  void _aplicarCambioTema() {
    if (selectedTheme.value == 'dark') {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
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

  // Nuevos métodos de navegación
  void goToResponseStyle() {
    Get.toNamed('/configuracionAI', arguments: user);
  }

  void goToPreferredLength() {
    Get.toNamed('/preferred-length', arguments: user);
  }

  void goToPrivacySettings() {
    Get.toNamed('/privacy-settings', arguments: user);
  }
}
