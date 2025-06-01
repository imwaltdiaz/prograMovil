// lib/pages/history/history_controller.dart

import 'package:get/get.dart';
import '../../models/conversacion.dart';
import '../../services/conversacion_service.dart';
import '../../models/user.dart';

class HistoryController extends GetxController {
  final ConversacionService conversacionService = ConversacionService();

  late final Usuario user; // Usuario que viene en los argumentos
  var conversaciones = <Conversacion>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _cargarConversaciones();
    } else {
      // Si no recibimos un usuario válido, volvemos atrás
      Get.back();
    }
  }

  Future<void> _cargarConversaciones() async {
    // Supongamos que el servicio retorna solo las conversaciones de ese usuario
    final lista =
        await conversacionService.getConversacionesPorUsuario(user.usuario_id);
    conversaciones.assignAll(lista);
  }

  /// Cuando el usuario toca una conversación, navegamos a Chat
  void abrirConversacion(Conversacion conv) {
    Get.toNamed(
      '/chat',
      arguments: {
        'user': user,
        'conversacion': conv,
      },
    );
  }
}
