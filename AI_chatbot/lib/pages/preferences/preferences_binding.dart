import 'package:get/get.dart';
import 'preferences_controller.dart';

class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferencesController>(() => PreferencesController());
  }
}
