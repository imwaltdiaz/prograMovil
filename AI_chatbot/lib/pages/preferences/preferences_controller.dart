import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesController extends GetxController {
  // Apariencia: theme claro u oscuro
  var isDarkMode = false.obs;

  // Notificaciones
  var notifyNewMessages = false.obs;
  var notifyUpdates = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Si deseas cargar valores guardados, puedes hacerlo aquí.
    // Por ejemplo, leer de SharedPreferences y asignar a estas variables reactivas.
  }

  /// Cambiar entre tema claro u oscuro
  void toggleTheme(bool value, BuildContext context) {
    isDarkMode.value = value;
    // Si usas ThemeMode en tu MaterialApp, aquí podrías forzar:
    // Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // O bien notificar al main para que cambie ThemeMode.
  }

  /// Cambiar notificación de mensajes nuevos
  void toggleNewMessages(bool value) {
    notifyNewMessages.value = value;
    // Guarda el valor si lo necesitas (en base local o remoto)
  }

  /// Cambiar notificación de actualizaciones
  void toggleUpdates(bool value) {
    notifyUpdates.value = value;
    // Guarda el valor si lo necesitas
  }

  /// Navegar a Editar Información de Perfil
  void goToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  /// Navegar a Historial de Chat
  void goToHistory(BuildContext context) {
    Navigator.pushNamed(context, '/history');
  }

  /// Navegar a estilo de respuesta (puedes definir la ruta real)
  void goToResponseStyle(BuildContext context) {
    Navigator.pushNamed(context, '/response-style');
  }

  /// Navegar a longitud preferida (puedes definir la ruta real)
  void goToPreferredLength(BuildContext context) {
    Navigator.pushNamed(context, '/preferred-length');
  }

  @override
  void onClose() {
    super.onClose();
    // Aquí podrías persistir los valores si quieres
  }
}
