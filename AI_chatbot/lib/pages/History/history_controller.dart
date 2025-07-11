import 'package:get/get.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import '../../services/conversacion_service.dart';

class HistoryController extends GetxController {
  final ConversacionService _conversacionService = ConversacionService();

  late final Usuario user;
  var conversaciones = <Conversacion>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    // Manejar tanto Usuario directo como Map con 'user'
    if (args is Usuario) {
      user = args;
    } else if (args is Map<String, dynamic> && args['user'] is Usuario) {
      user = args['user'] as Usuario;
    } else {
      print(
          '>> [HistoryController] No vino un Usuario válido en Get.arguments. Volviendo atrás.');
      print('>> [HistoryController] Argumentos recibidos: $args');
      Get.back();
      return;
    }

    print(
        '>> [HistoryController] Usuario logueado: ${user.email} (id=${user.usuario_id})');
    _cargarConversaciones();
  }

  Future<void> _cargarConversaciones() async {
    isLoading.value = true;
    final lista =
        await _conversacionService.getConversacionesPorUsuario(user.usuario_id);
    conversaciones.assignAll(lista);
    isLoading.value = false;
    print(
        '>> [HistoryController] Conversaciones cargadas: ${conversaciones.length}');
  }

  Future<void> refrescar() async {
    await _cargarConversaciones();
  }
}
