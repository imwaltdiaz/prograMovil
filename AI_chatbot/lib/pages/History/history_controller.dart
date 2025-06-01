// lib/pages/history/history_controller.dart

import 'package:get/get.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import '../../services/conversacion_service.dart';

class HistoryController extends GetxController {
  final ConversacionService _conversacionService = ConversacionService();

  /// El usuario que recibimos en Get.arguments
  late final Usuario user;

  /// Lista reactiva de todas las conversaciones de este usuario
  var conversaciones = <Conversacion>[].obs;

  /// Indicador de carga
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _cargarConversaciones();
    } else {
      // Si no vino un Usuario válido, simplemente volvemos atrás
      Get.back();
    }
  }

  Future<void> _cargarConversaciones() async {
    isLoading.value = true;
    final lista =
        await _conversacionService.getConversacionesPorUsuario(user.usuario_id);
    conversaciones.assignAll(lista);
    isLoading.value = false;
  }

  /// Para hacer pull-to-refresh
  Future<void> refrescar() async {
    await _cargarConversaciones();
  }
}
