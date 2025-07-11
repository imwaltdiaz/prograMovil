// lib/configs/api_config.dart

class ApiConfig {
  // Configuración del servidor backend
  // Diferentes opciones para diferentes dispositivos
  static const String _localhost = 'http://localhost:3001';
  static const String _emulatorAndroid = 'http://10.0.2.2:3001';
  static const String _realDevice =
      'http://192.168.1.100:3001'; // Cambiar por tu IP local

  // URL actual - cambiar según el dispositivo
  static String get baseUrl {
    // Puedes cambiar esto dinámicamente o usar _localhost, _realDevice
    return _emulatorAndroid;
  }

  static const String apiVersion = '/api';
  static String get fullBaseUrl => '$baseUrl$apiVersion';

  // Endpoints de autenticación
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authVerify = '/auth/verify';

  // Endpoints de usuarios
  static const String usersProfile = '/users/profile';

  // Endpoints de chat
  static const String chatMessage = '/chat/message';
  static const String chatHistory = '/chat/history';
  static const String chatConversation = '/chat/conversation';

  // Endpoints de conversaciones
  static const String conversations = '/conversations';

  // Endpoints de modelos IA
  static const String aiModels = '/ai-models';
  static const String aiModelsAll = '/ai-models/all';
  static const String aiModelsDefault = '/ai-models/default';

  // Endpoints de preferencias
  static const String preferences = '/preferences';
  static const String preferencesDefaultModel = '/preferences/default-model';

  // Endpoints de mensajes
  static const String messages = '/messages';

  // Configuración de timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Claves para SharedPreferences
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
}
