import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user.dart';

class ProfileService {
  static const String _assetPath = 'assets/jsons/users.json';

  /// Carga y parsea todo el JSON en una lista de Usuario
  Future<List<Usuario>> _loadAllUsuarios() async {
    // 1) Leer el JSON completo como string
    final jsonString = await rootBundle.loadString(_assetPath);

    // 2) Decodificar a Map<String, dynamic>
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    // 3) Extraer el arreglo bajo la clave "usuarios"
    final List<dynamic> usuariosListDynamic =
        jsonMap['usuarios'] as List<dynamic>;

    // 4) Convertir cada Map<String, dynamic> en Usuario
    final List<Usuario> usuarios = usuariosListDynamic
        .map((item) => Usuario.fromJson(item as Map<String, dynamic>))
        .toList();

    return usuarios;
  }

  /// Busca un usuario por su ID. Retorna null si no se encuentra.
  Future<Usuario?> getUsuarioPorId(int usuarioId) async {
    final all = await _loadAllUsuarios();
    try {
      return all.firstWhere((u) => u.usuario_id == usuarioId);
    } catch (_) {
      return null;
    }
  }

  /// Busca un usuario por su email. Retorna null si no se encuentra.
  Future<Usuario?> getUsuarioPorEmail(String email) async {
    final all = await _loadAllUsuarios();
    try {
      return all.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }
}
