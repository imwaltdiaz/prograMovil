// lib/pages/configuracionAI/configuracionAI_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/modelo_ia.dart';
import '../../services/modelo_ia_service.dart';

/// Enumeración de proveedores de IA (coincide con la clave "proveedor" en el JSON)
enum AIProvider { openAI, azureOpenAI, anthropic, googleGemini }

class AIConfigController extends GetxController {
  final ModeloIAService modeloIAService = ModeloIAService();

  /// Proveedor de IA seleccionado (por defecto: openAI)
  Rx<AIProvider> selectedProvider = AIProvider.openAI.obs;

  /// Lista de objetos ModeloIA disponibles para el proveedor actual
  RxList<ModeloIA> availableModelObjects = <ModeloIA>[].obs;

  /// Identificador interno del modelo seleccionado (por ejemplo "gpt-4o")
  RxnString selectedModelKey = RxnString();

  /// API Key (placeholder inicial “••••••••••••”)
  final TextEditingController apiKeyController =
      TextEditingController(text: 'xdxdxdxddddddxdddddddddddddddddd');

  /// Controla la visibilidad de la API Key
  RxBool isApiKeyVisible = false.obs;

  /// Temperatura (0.0 a 1.0)
  RxDouble temperature = 0.7.obs;

  /// Max tokens (ejemplo: 4096)
  RxDouble maxTokens = 4096.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Al inicializar el controlador, cargamos los modelos del proveedor por defecto (openAI)
    _loadModelsForProvider(selectedProvider.value);
  }

  /// Convierte el enum AIProvider en la clave exacta usada en el JSON
  String _providerKey(AIProvider p) {
    switch (p) {
      case AIProvider.openAI:
        return 'openAI';
      case AIProvider.azureOpenAI:
        return 'azureOpenAI';
      case AIProvider.anthropic:
        return 'anthropic';
      case AIProvider.googleGemini:
        return 'googleGemini';
    }
  }

  /// Llama a getModelosPorProveedor(...) y actualiza la lista reactiva
  Future<void> _loadModelsForProvider(AIProvider provider) async {
    final key = _providerKey(provider);
    final List<ModeloIA> lista =
        await modeloIAService.getModelosPorProveedor(key);
    availableModelObjects.assignAll(lista);

    // Si hay modelos, preseleccionamos el primero; si no, queda en null
    if (lista.isNotEmpty) {
      selectedModelKey.value = lista.first.identificador_interno_modelo;
    } else {
      selectedModelKey.value = null;
    }

    // >>> Aquí añadimos el print de lo que se cargó <<<
    print('Modelos cargados para el proveedor $key:');
    for (var modelo in availableModelObjects) {
      print(
          '• Nombre: ${modelo.nombre}, ID Interno: ${modelo.identificador_interno_modelo}');
    }
  }

  /// Cuando el usuario selecciona un proveedor distinto (RadioListTile)
  void onProviderChanged(AIProvider newProvider) {
    if (newProvider != selectedProvider.value) {
      selectedProvider.value = newProvider;
      _loadModelsForProvider(newProvider);
    }
  }

  /// Cuando el usuario elige un modelo distinto en el Dropdown
  void onModelChanged(String? newModelKey) {
    if (newModelKey != null) {
      selectedModelKey.value = newModelKey;
    }
  }

  /// Cuando el slider de temperatura cambia
  void onTemperatureChanged(double v) {
    temperature.value = v;
  }

  /// Cuando el slider de maxTokens cambia
  void onMaxTokensChanged(double v) {
    maxTokens.value = v;
  }

  /// Al pulsar “Guardar” en la UI, mostramos un Snackbar de confirmación.
  Future<void> saveConfig() async {
    final providerName = _providerKey(selectedProvider.value);
    final modelKey = selectedModelKey.value ?? 'ninguno';
    final apiKey = apiKeyController.text.trim();
    final tempStr = temperature.value.toStringAsFixed(1);
    final tokens = maxTokens.value.round();

    Get.snackbar(
      'Configuración guardada',
      'Proveedor: $providerName\n'
          'Modelo: $modelKey\n'
          'API Key: $apiKey\n'
          'Temperatura: $tempStr\n'
          'Max Tokens: $tokens',
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    apiKeyController.dispose();
    super.onClose();
  }
}
