// lib/services/preferencia_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/preferencia_usuario.dart';

class PreferenciaService {
  /// Carga todas las filas de preferencias desde JSON.
  Future<List<PreferenciaUsuario>> _loadAllPreferencias() async {
    final raw =
        await rootBundle.loadString('assets/jsons/preferencias_usuario.json');
    final Map<String, dynamic> jsonMap =
        json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> listaJson = jsonMap['preferencias'] as List<dynamic>;
    return listaJson
        .map((p) => PreferenciaUsuario.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene la preferencia del usuario indicado (por userId).
  /// Devuelve null si no existe.
  Future<PreferenciaUsuario?> getPreferenciaPorUsuario(int userId) async {
    final todas = await _loadAllPreferencias();
    try {
      return todas.firstWhere((p) => p.usuario_id == userId);
    } catch (_) {
      return null;
    }
  }

  /// “Guarda” (inserta o actualiza) la preferencia de ese usuario.
  /// Como este mock no escribe en disco, devolvemos true para simular éxito.
  Future<bool> guardarPreferenciaUsuario(int userId, int modeloId) async {
    // En una implementación real, aquí harías un INSERT o UPDATE
    // en tu base de datos. Por ahora, devolvemos true:
    return true;
  }
}
