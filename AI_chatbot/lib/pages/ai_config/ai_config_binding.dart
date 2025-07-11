import 'package:get/get.dart';
import 'ai_config_controller.dart';

class AIConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AIConfigController>(() => AIConfigController());
  }
}
