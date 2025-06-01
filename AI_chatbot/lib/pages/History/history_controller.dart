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
    if (args is Usuario) {
      user = args;
      print(
          '>> [HistoryController] Usuario logueado: ${user.email} (id=${user.usuario_id})');
      _cargarConversaciones();
    } else {
      print(
          '>> [HistoryController] No vino un Usuario en Get.arguments. Volviendo atrás.');
      Get.back();
    }
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
