// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import '../configs/api_config.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// Login con email y contraseña
  Future<ApiResponse<Usuario>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Guardar token
        if (data['token'] != null) {
          await _apiService.saveToken(data['token']);
        }

        // Crear usuario desde la respuesta
        if (data['user'] != null) {
          try {
            final usuario = Usuario.fromJson(data['user']);
            await _apiService.saveUserData(data['user']);

            return ApiResponse.success(
              usuario,
              data['message'] ?? 'Login exitoso',
            );
          } catch (e) {
            print('Error creando usuario desde JSON: $e');
            print('Datos recibidos: ${data['user']}');
            return ApiResponse.error('Error procesando datos de usuario: $e');
          }
        } else {
          return ApiResponse.error('Error: No se recibieron datos de usuario');
        }
      } else {
        return ApiResponse.error(
          response.data['message'] ?? 'Error de autenticación',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        return ApiResponse.error(
          errorData['message'] ?? 'Error de conexión',
          validationErrors: errorData['details'] != null
              ? (errorData['details'] as List)
                  .map((e) => ValidationError.fromJson(e))
                  .toList()
              : null,
        );
      } else {
        return ApiResponse.error(
          'Error de conexión: Verifica que el servidor esté funcionando',
        );
      }
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  /// Registro de nuevo usuario
  Future<ApiResponse<Usuario>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;

        // Guardar token
        if (data['token'] != null) {
          await _apiService.saveToken(data['token']);
        }

        // Crear usuario desde la respuesta
        if (data['user'] != null) {
          final usuario = Usuario.fromJson(data['user']);
          await _apiService.saveUserData(data['user']);

          return ApiResponse.success(
            usuario,
            data['message'] ?? 'Registro exitoso',
          );
        } else {
          return ApiResponse.error('Error: No se recibieron datos de usuario');
        }
      } else {
        return ApiResponse.error(
          response.data['message'] ?? 'Error en el registro',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        return ApiResponse.error(
          errorData['message'] ?? 'Error de conexión',
          validationErrors: errorData['details'] != null
              ? (errorData['details'] as List)
                  .map((e) => ValidationError.fromJson(e))
                  .toList()
              : null,
        );
      } else {
        return ApiResponse.error(
          'Error de conexión: Verifica que el servidor esté funcionando',
        );
      }
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  /// Verificar token actual
  Future<ApiResponse<Usuario>> verifyToken() async {
    try {
      final hasToken = await _apiService.hasToken();
      if (!hasToken) {
        return ApiResponse.error('No hay token de autenticación');
      }

      final response = await _apiService.get(ApiConfig.authVerify);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['user'] != null) {
          final usuario = Usuario.fromJson(data['user']);
          await _apiService.saveUserData(data['user']);

          return ApiResponse.success(
            usuario,
            data['message'] ?? 'Token válido',
          );
        } else {
          return ApiResponse.error('Error: No se recibieron datos de usuario');
        }
      } else {
        // Token inválido, limpiar datos
        await logout();
        return ApiResponse.error(
          response.data['message'] ?? 'Token inválido',
        );
      }
    } on DioException catch (e) {
      // En caso de error, limpiar datos de autenticación
      await logout();

      if (e.response != null) {
        return ApiResponse.error(
          e.response!.data['message'] ?? 'Token inválido',
        );
      } else {
        return ApiResponse.error('Error de conexión');
      }
    } catch (e) {
      await logout();
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  /// Logout - limpiar datos locales
  Future<void> logout() async {
    await _apiService.removeToken();
    await _apiService.clearUserData();
  }

  /// Verificar si el usuario está logueado
  Future<bool> isLoggedIn() async {
    return await _apiService.isLoggedIn() && await _apiService.hasToken();
  }

  /// Obtener token actual
  Future<String?> getCurrentToken() async {
    return await _apiService.getToken();
  }
}
