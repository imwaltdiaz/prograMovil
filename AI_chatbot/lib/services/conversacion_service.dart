// lib/services/conversacion_service.dart

import '../models/conversacion.dart';
import '../configs/api_config.dart';
import 'api_service.dart';

class ConversacionService {
  final ApiService _apiService = ApiService();

  Future<List<Conversacion>> getConversacionesPorUsuario(int usuarioId) async {
    try {
      print(
          '>> [ConversacionService] Cargando conversaciones para usuario $usuarioId desde API...');

      final response = await _apiService.get(ApiConfig.conversations);

      print('>> [ConversacionService] Status Code: ${response.statusCode}');
      print('>> [ConversacionService] Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Manejar diferentes formatos de respuesta
        List<dynamic> conversacionesJson = [];

        if (responseData is List) {
          conversacionesJson = responseData;
        } else if (responseData is Map<String, dynamic>) {
          conversacionesJson = responseData['conversations'] ??
              responseData['data'] ??
              responseData['conversaciones'] ??
              [];
        }

        final conversaciones = conversacionesJson
            .map((json) => Conversacion.fromJson(json as Map<String, dynamic>))
            .toList();

        print(
            '>> [ConversacionService] ${conversaciones.length} conversaciones cargadas desde API');
        return conversaciones;
      } else {
        print('>> [ConversacionService] Error API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('>> [ConversacionService] Error cargando conversaciones: $e');
      print('>> [ConversacionService] Stack trace: ${StackTrace.current}');
      // Fallback: retornar lista vacía en lugar de fallar
      return [];
    }
  }

  Future<Conversacion?> crearConversacion({
    required int usuarioId,
    required String titulo,
    int? modeloIaId,
  }) async {
    try {
      print('>> [ConversacionService] Creando nueva conversación: $titulo');

      final response = await _apiService.post(
        ApiConfig.conversations,
        data: {
          'usuario_id': usuarioId,
          'titulo': titulo,
          'modelo_ia_id': modeloIaId ?? 1, // ID por defecto
        },
      );

      print('>> [ConversacionService] Status Code: ${response.statusCode}');
      print('>> [ConversacionService] Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        // Extraer los datos de la conversación
        Map<String, dynamic> conversacionData;
        if (responseData is Map<String, dynamic>) {
          conversacionData = responseData['conversation'] ??
              responseData['data'] ??
              responseData;
        } else {
          print('>> [ConversacionService] Formato de respuesta inesperado');
          return null;
        }

        final conversacion = Conversacion.fromJson(conversacionData);
        print(
            '>> [ConversacionService] Conversación creada: ${conversacion.conversacion_id}');
        return conversacion;
      } else {
        print(
            '>> [ConversacionService] Error creando conversación: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('>> [ConversacionService] Error creando conversación: $e');
      return null;
    }
  }

  /// Actualizar una conversación existente
  Future<bool> actualizarConversacion(int conversacionId,
      {String? titulo}) async {
    try {
      print(
          '>> [ConversacionService] Actualizando conversación $conversacionId');

      final response = await _apiService.put(
        '${ApiConfig.conversations}/$conversacionId',
        data: {
          if (titulo != null) 'titulo': titulo,
        },
      );

      print(
          '>> [ConversacionService] Update Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('>> [ConversacionService] Conversación actualizada exitosamente');
        return true;
      } else {
        print(
            '>> [ConversacionService] Error actualizando: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('>> [ConversacionService] Error actualizando conversación: $e');
      return false;
    }
  }
}
