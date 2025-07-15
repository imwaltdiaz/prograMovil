// lib/configs/api_config.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Configuración del servidor backend
  static const String _localhost = 'http://localhost:3001';
  static const String _emulatorAndroid = 'http://10.0.2.2:3001';

  // URL actual - detecta automáticamente el entorno
  static String get baseUrl {
    if (kIsWeb) {
      // En web, usar localhost
      return _localhost;
    } else if (Platform.isAndroid) {
      // En Android emulator, usar 10.0.2.2
      return _emulatorAndroid;
    } else {
      // iOS y otros: usar localhost
      return _localhost;
    }
  }

  static const String apiVersion = '/api';
  static String get fullBaseUrl => '$baseUrl$apiVersion';

  // Endpoints de autenticación
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authVerify = '/auth/verify';

  // Endpoints de usuarios
  static const String usersProfile = '/users/profile';
  static const String usersChangePassword = '/users/change-password';

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
