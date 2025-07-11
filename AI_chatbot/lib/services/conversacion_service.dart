// lib/services/conversacion_service.dart

import '../models/conversacion.dart';
import '../configs/api_config.dart';
import 'api_service.dart';

class ConversacionService {
  final ApiService _apiService = ApiService();

  Future<List<Conversacion>> getConversacionesPorUsuario(int usuarioId) async {
    try {
      print('>> [ConversacionService] Cargando conversaciones para usuario $usuarioId desde API...');
      
      final response = await _apiService.get(
        '${ApiConfig.conversations}?usuario_id=$usuarioId'
      );

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
                              responseData['conversaciones'] ?? [];
        }

        final conversaciones = conversacionesJson
            .map((json) => Conversacion.fromJson(json as Map<String, dynamic>))
            .toList();

        print('>> [ConversacionService] ${conversaciones.length} conversaciones cargadas desde API');
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
}
