// lib/services/usuario_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class UsuarioService {
  /// Carga todos los usuarios desde el JSON (assets/jsons/users.json).
  Future<List<Usuario>> _loadAllUsuarios() async {
    final raw = await rootBundle.loadString('assets/jsons/users.json');
    final Map<String, dynamic> jsonMap =
        json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> listaJson = jsonMap['usuarios'] as List<dynamic>;
    return listaJson
        .map((u) => Usuario.fromJson(u as Map<String, dynamic>))
        .toList();
  }

  /// Busca un usuario por su email. Retorna null si no existe.
  Future<Usuario?> getUsuarioPorEmail(String email) async {
    final todos = await _loadAllUsuarios();
    try {
      return todos.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  /// Busca un usuario por su ID. Retorna null si no existe.
  Future<Usuario?> getUsuarioPorId(int usuarioId) async {
    final todos = await _loadAllUsuarios();
    try {
      return todos.firstWhere((u) => u.usuario_id == usuarioId);
    } catch (_) {
      return null;
    }
  }

  /// “Actualiza” un usuario. Como este ejemplo usa solo JSON de lectura,
  /// aquí simulamos éxito devolviendo true. Luego puedes sustituirlo
  /// por un INSERT/UPDATE real a base de datos.
  Future<bool> actualizarUsuario(Usuario usuario) async {
    // En un escenario real, escribirías en SQLite o en un servidor remoto.
    // Aquí solo devolvemos true para indicar que “fue posible actualizarlo”.
    return true;
  }
}
