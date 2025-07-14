import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiAIService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  // 🔑 COLOCA TU API KEY AQUÍ (Para pruebas rápidas)
  static const String _hardcodedApiKey = 'xddddddddddddddddddddddddddddddddddd';

  /// Obtener la configuración del usuario desde SharedPreferences
  Future<Map<String, dynamic>> _getUserConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'apiKey': _hardcodedApiKey.isNotEmpty
          ? _hardcodedApiKey
          : prefs.getString('ai_api_key') ?? '',
      'temperatura': prefs.getDouble('ai_temperatura') ?? 0.7,
      'maxTokens': prefs.getInt('ai_max_tokens') ?? 4096,
    };
  }

  /// Enviar mensaje a Gemini y obtener respuesta
  Future<String> sendMessage(String message) async {
    try {
      final config = await _getUserConfig();
      final apiKey = config['apiKey'] as String;

      if (apiKey.isEmpty || apiKey == 'TU_API_KEY_AQUI') {
        throw Exception(
            'API Key no configurada. Reemplaza TU_API_KEY_AQUI en gemini_ai_service.dart con tu clave real.');
      }

      final url = Uri.parse(
          '$_baseUrl/models/gemini-2.0-flash-exp:generateContent?key=$apiKey');

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': message}
            ]
          }
        ],
        'generationConfig': {
          'temperature': config['temperatura'],
          'maxOutputTokens': config['maxTokens'],
          'topP': 0.8,
          'topK': 40
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      print('🚀 Enviando mensaje a Gemini...');
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

        // Extraer el texto de la respuesta de Gemini
        if (responseData['candidates'] != null &&
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0]['content'] != null &&
            responseData['candidates'][0]['content']['parts'] != null &&
            responseData['candidates'][0]['content']['parts'].isNotEmpty) {
          final responseText =
              responseData['candidates'][0]['content']['parts'][0]['text'];
          print('✅ Respuesta de Gemini recibida');
          return responseText;
        } else {
          throw Exception('Formato de respuesta inesperado de Gemini');
        }
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Error de API';
        throw Exception('Error de Gemini: $errorMessage');
      } else if (response.statusCode == 403) {
        throw Exception(
            'API Key inválida o sin permisos. Verifica tu API Key en la configuración.');
      } else if (response.statusCode == 429) {
        throw Exception(
            'Límite de solicitudes excedido. Intenta de nuevo en unos minutos.');
      } else {
        throw Exception(
            'Error del servidor de Gemini (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error en GeminiAIService: $e');
      rethrow;
    }
  }

  /// Verificar si la API Key es válida
  Future<bool> validateApiKey(String apiKey) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/models/gemini-2.0-flash-exp:generateContent?key=$apiKey');

      final testBody = {
        'contents': [
          {
            'parts': [
              {'text': 'Hola'}
            ]
          }
        ]
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(testBody),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error validando API Key: $e');
      return false;
    }
  }

  /// Obtener información de los modelos disponibles
  Future<List<String>> getAvailableModels() async {
    try {
      final config = await _getUserConfig();
      final apiKey = config['apiKey'] as String;

      if (apiKey.isEmpty) {
        return ['gemini-pro']; // Modelo por defecto
      }

      final url = Uri.parse('$_baseUrl/models?key=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final models = <String>[];

        if (responseData['models'] != null) {
          for (final model in responseData['models']) {
            if (model['name'] != null) {
              final modelName = model['name'].toString().split('/').last;
              models.add(modelName);
            }
          }
        }

        return models.isNotEmpty ? models : ['gemini-2.0-flash-exp'];
      } else {
        return ['gemini-2.0-flash-exp']; // Fallback
      }
    } catch (e) {
      print('Error obteniendo modelos: $e');
      return ['gemini-2.0-flash-exp']; // Fallback
    }
  }
}
