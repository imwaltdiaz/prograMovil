// lib/services/conversacion_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/conversacion.dart';

class ConversacionService {
  /// Carga todas las conversaciones desde JSON.
  Future<List<Conversacion>> _loadAllConversaciones() async {
    final raw = await rootBundle.loadString('assets/jsons/conversaciones.json');
    final Map<String, dynamic> jsonMap =
        json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> listaJson = jsonMap['conversaciones'] as List<dynamic>;
    return listaJson
        .map((c) => Conversacion.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  /// Devuelve solo las conversaciones que pertenecen al usuario dado.
  Future<List<Conversacion>> getConversacionesPorUsuario(int userId) async {
    final todas = await _loadAllConversaciones();
    return todas.where((c) => c.usuario_id == userId).toList();
  }

  /// “Crear” una nueva conversación. Simulación: siempre devuelve true.
  Future<bool> crearConversacion(Conversacion nueva) async {
    // Si fuera real, harías un INSERT en base de datos.
    // Aquí simulamos éxito:
    return true;
  }
}
