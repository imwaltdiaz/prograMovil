import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/modelo_ia.dart';
import '../../services/modelo_ia_service.dart';
import '../../services/preferencia_usuario_service.dart';

class AIConfigController extends GetxController {
  final ModeloIAService modeloIAService = ModeloIAService();
  final PreferenciaService preferenciaService = PreferenciaService();

  late final Usuario user;

  // Lista de proveedores disponibles
  var proveedores = <String>[].obs;
  
  // Lista de modelos disponibles para el proveedor seleccionado
  var modelosDisponibles = <ModeloIA>[].obs;
  
  // Proveedor seleccionado
  var proveedorSeleccionado = 'OpenAI'.obs;
  
  // Modelo seleccionado
  Rx<ModeloIA?> modeloSeleccionado = Rxn<ModeloIA>();
  
  // API Key del usuario (almacenada localmente)
  var apiKey = ''.obs;
  var apiKeyVisible = false.obs;
  
  // Parámetros de IA
  var temperatura = 0.7.obs;
  var maxTokens = 4096.obs;
  
  // Estados
  var isLoading = false.obs;
  var message = ''.obs;
  var isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Usuario) {
      user = args;
      _initializeData();
    } else {
      Get.back();
    }
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      // Cargar modelos y obtener proveedores únicos
      await _cargarModelos();
      
      // Cargar preferencias del usuario
      await _cargarPreferenciasUsuario();
      
      // Cargar configuración local (API Key y parámetros)
      await _cargarConfiguracionLocal();
      
    } catch (e) {
      message.value = 'Error al cargar la configuración: $e';
      isSuccess.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _cargarModelos() async {
    try {
      final modelos = await modeloIAService.getTodosModelosIA();
      
      // Extraer proveedores únicos
      final providersSet = modelos.map((m) => m.proveedor).toSet();
      proveedores.assignAll(providersSet.toList());
      
      // Cargar modelos para el proveedor por defecto
      await _cargarModelosPorProveedor(proveedorSeleccionado.value);
      
    } catch (e) {
      print('Error cargando modelos: $e');
    }
  }

  Future<void> _cargarModelosPorProveedor(String proveedor) async {
    try {
      final modelos = await modeloIAService.getTodosModelosIA();
      final modelosProveedor = modelos.where((m) => m.proveedor == proveedor).toList();
      modelosDisponibles.assignAll(modelosProveedor);
      
      // Si no hay modelo seleccionado, seleccionar el primero
      if (modeloSeleccionado.value == null && modelosProveedor.isNotEmpty) {
        modeloSeleccionado.value = modelosProveedor.first;
      }
    } catch (e) {
      print('Error cargando modelos por proveedor: $e');
    }
  }

  Future<void> _cargarPreferenciasUsuario() async {
    try {
      final preferencia = await preferenciaService.getPreferenciaPorUsuario(user.usuario_id);
      if (preferencia != null) {
        // Buscar el modelo por ID en la lista de modelos cargados
        final modelos = await modeloIAService.getTodosModelosIA();
        final modelo = modelos.firstWhereOrNull((m) => m.modelo_ia_id == preferencia.modelo_ia_default_id);
        if (modelo != null) {
          modeloSeleccionado.value = modelo;
          proveedorSeleccionado.value = modelo.proveedor;
          await _cargarModelosPorProveedor(modelo.proveedor);
        }
      }
    } catch (e) {
      print('Error cargando preferencias: $e');
    }
  }

  Future<void> _cargarConfiguracionLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      apiKey.value = prefs.getString('ai_api_key') ?? '';
      temperatura.value = prefs.getDouble('ai_temperatura') ?? 0.7;
      maxTokens.value = prefs.getInt('ai_max_tokens') ?? 4096;
    } catch (e) {
      print('Error cargando configuración local: $e');
      // Valores por defecto
      apiKey.value = '';
      temperatura.value = 0.7;
      maxTokens.value = 4096;
    }
  }

  void cambiarProveedor(String nuevoProveedor) async {
    if (nuevoProveedor != proveedorSeleccionado.value) {
      proveedorSeleccionado.value = nuevoProveedor;
      modeloSeleccionado.value = null;
      await _cargarModelosPorProveedor(nuevoProveedor);
    }
  }

  void cambiarModelo(ModeloIA? nuevoModelo) {
    modeloSeleccionado.value = nuevoModelo;
  }

  void toggleApiKeyVisibility() {
    apiKeyVisible.value = !apiKeyVisible.value;
  }

  void updateTemperatura(double value) {
    temperatura.value = value;
  }

  void updateMaxTokens(double value) {
    maxTokens.value = value.round();
  }

  Future<void> guardarConfiguracion() async {
    if (modeloSeleccionado.value == null) {
      message.value = 'Debe seleccionar un modelo';
      isSuccess.value = false;
      return;
    }

    if (apiKey.value.trim().isEmpty) {
      message.value = 'Debe ingresar una API Key';
      isSuccess.value = false;
      return;
    }

    isLoading.value = true;
    try {
      // Guardar preferencia del modelo en el backend
      await preferenciaService.guardarPreferenciaUsuario(
        user.usuario_id,
        modeloSeleccionado.value!.modelo_ia_id,
      );

      // Guardar API Key y parámetros localmente
      await _guardarConfiguracionLocal();

      message.value = 'Configuración guardada exitosamente';
      isSuccess.value = true;

      // Mostrar mensaje temporal
      Future.delayed(const Duration(seconds: 3), () {
        message.value = '';
      });

    } catch (e) {
      message.value = 'Error al guardar: $e';
      isSuccess.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _guardarConfiguracionLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ai_api_key', apiKey.value);
      await prefs.setDouble('ai_temperatura', temperatura.value);
      await prefs.setInt('ai_max_tokens', maxTokens.value);
      print('Configuración local guardada exitosamente');
    } catch (e) {
      print('Error guardando configuración local: $e');
      throw e;
    }
  }

  String get modeloSeleccionadoNombre {
    if (modeloSeleccionado.value != null) {
      return '${modeloSeleccionado.value!.nombre} (${modeloSeleccionado.value!.proveedor})';
    }
    return modelosDisponibles.isNotEmpty 
      ? '${modelosDisponibles.first.nombre} (${modelosDisponibles.first.proveedor})'
      : 'GPT-4O (OpenAI)';
  }

  List<String> get modelosNombres {
    return modelosDisponibles.map((m) => '${m.nombre} (${m.proveedor})').toList();
  }
}
