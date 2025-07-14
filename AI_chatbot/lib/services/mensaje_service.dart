// lib/services/mensaje_service.dart

import '../models/mensaje.dart';
import '../configs/api_config.dart';
import 'api_service.dart';

class MensajeService {
  final ApiService _apiService = ApiService();

  Future<List<Mensaje>> getMensajesPorConversacion(int conversacionId) async {
    try {
      print(
          '>> [MensajeService] Cargando mensajes para conversación $conversacionId desde API...');

      final response = await _apiService
          .get('${ApiConfig.messages}/conversation/$conversacionId');

      print('>> [MensajeService] Status Code: ${response.statusCode}');
      print('>> [MensajeService] Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Manejar diferentes formatos de respuesta
        List<dynamic> mensajesJson = [];

        if (responseData is List) {
          mensajesJson = responseData;
        } else if (responseData is Map<String, dynamic>) {
          mensajesJson = responseData['messages'] ??
              responseData['data'] ??
              responseData['mensajes'] ??
              [];
        }

        final mensajes = mensajesJson
            .map((json) => Mensaje.fromJson(json as Map<String, dynamic>))
            .toList();

        print(
            '>> [MensajeService] ${mensajes.length} mensajes cargados desde API');
        return mensajes;
      } else {
        print('>> [MensajeService] Error del servidor: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('>> [MensajeService] Error cargando mensajes desde API: $e');
      return [];
    }
  }

  Future<bool> guardarMensaje(Mensaje mensaje) async {
    try {
      print(
          '>> [MensajeService] Guardando mensaje: ${mensaje.contenido_texto}');

      final response = await _apiService.post(
        ApiConfig.messages,
        data: {
          'conversacion_id': mensaje.conversacion_id,
          'remitente':
              mensaje.remitente == RemitenteType.usuario ? 'user' : 'assistant',
          'contenido_texto': mensaje.contenido_texto,
          'timestamp_envio': mensaje.timestamp_envio.toIso8601String(),
        },
      );

      print('>> [MensajeService] Status Code: ${response.statusCode}');
      print('>> [MensajeService] Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('>> [MensajeService] Mensaje guardado exitosamente');
        return true;
      } else {
        print(
            '>> [MensajeService] Error guardando mensaje: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('>> [MensajeService] Error guardando mensaje: $e');
      return false;
    }
  }
}
