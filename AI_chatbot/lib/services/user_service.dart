// lib/services/user_service.dart

import '../models/user.dart';
import '../configs/api_config.dart';
import 'api_service.dart';
import '../models/api_response.dart';

class UserService {
  final ApiService _apiService = ApiService();

  /// Obtener perfil del usuario autenticado
  Future<ApiResponse<Usuario>> getProfile() async {
    try {
      print('>> [UserService] Obteniendo perfil del usuario...');
      
      final response = await _apiService.get(ApiConfig.usersProfile);

      print('>> [UserService] Status Code: ${response.statusCode}');
      print('>> [UserService] Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic> && responseData['user'] != null) {
          final userData = responseData['user'] as Map<String, dynamic>;
          final usuario = Usuario.fromJson(userData);
          
          print('>> [UserService] Perfil obtenido: ${usuario.email}');
          return ApiResponse.success(usuario, 'Perfil obtenido exitosamente');
        } else {
          return ApiResponse.error('Error: No se recibieron datos de usuario');
        }
      } else {
        final errorData = response.data as Map<String, dynamic>?;
        return ApiResponse.error(
          errorData?['message'] ?? 'Error obteniendo perfil',
        );
      }
    } catch (e) {
      print('>> [UserService] Error obteniendo perfil: $e');
      return ApiResponse.error('Error de conexión: $e');
    }
  }

  /// Actualizar perfil del usuario
  Future<ApiResponse<Usuario>> updateProfile({
    required String nombre,
    required String email,
  }) async {
    try {
      print('>> [UserService] Actualizando perfil: $nombre, $email');
      
      final response = await _apiService.put(
        ApiConfig.usersProfile,
        data: {
          'nombre': nombre,
          'email': email,
        },
      );

      print('>> [UserService] Status Code: ${response.statusCode}');
      print('>> [UserService] Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic> && responseData['user'] != null) {
          final userData = responseData['user'] as Map<String, dynamic>;
          final usuario = Usuario.fromJson(userData);
          
          print('>> [UserService] Perfil actualizado: ${usuario.email}');
          return ApiResponse.success(usuario, 'Perfil actualizado exitosamente');
        } else {
          return ApiResponse.error('Error: No se recibieron datos de usuario actualizados');
        }
      } else {
        final errorData = response.data as Map<String, dynamic>?;
        return ApiResponse.error(
          errorData?['message'] ?? 'Error actualizando perfil',
        );
      }
    } catch (e) {
      print('>> [UserService] Error actualizando perfil: $e');
      return ApiResponse.error('Error de conexión: $e');
    }
  }
}
