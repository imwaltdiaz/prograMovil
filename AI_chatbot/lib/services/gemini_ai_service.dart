import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiAIService {
  // URL de nuestro backend local
  static const String _backendUrl = 'http://localhost:3001/api';

  /// Enviar mensaje a través de nuestro backend
  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_backendUrl/genai');

      final requestBody = {
        'contents': message,
      };

      print('🚀 Enviando mensaje al backend...');
      print('📤 URL: $url');
      print('📝 Mensaje: $message');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📨 Response status: ${response.statusCode}');
      print('📋 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['text'] != null) {
          print('✅ Respuesta del backend recibida');
          return responseData['text'];
        } else {
          throw Exception('Formato de respuesta inesperado del backend');
        }
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Error de solicitud';
        throw Exception('Error del backend: $errorMessage');
      } else {
        throw Exception('Error del servidor backend (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error en GeminiAIService: $e');
      rethrow;
    }
  }

  /// Verificar conexión con el backend
  Future<bool> validateConnection() async {
    try {
      final url = Uri.parse('$_backendUrl/../');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Error validando conexión: $e');
      return false;
    }
  }

  /// Obtener información de los modelos disponibles (desde backend)
  Future<List<String>> getAvailableModels() async {
    try {
      // Por ahora retornamos modelos estáticos, pero esto podría venir del backend
      return ['gemini-2.0-flash-exp', 'gemini-pro'];
    } catch (e) {
      print('Error obteniendo modelos: $e');
      return ['gemini-2.0-flash-exp']; // Fallback
    }
  }
}
