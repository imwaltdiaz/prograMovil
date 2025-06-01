// lib/services/mensaje_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/mensaje.dart';

class MensajeService {
  /// Carga todos los mensajes desde JSON.
  Future<List<Mensaje>> _loadAllMensajes() async {
    final raw = await rootBundle.loadString('assets/jsons/mensajes.json');
    final Map<String, dynamic> jsonMap =
        json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> listaJson = jsonMap['mensajes'] as List<dynamic>;
    return listaJson
        .map((m) => Mensaje.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  /// Filtra y retorna únicamente los mensajes de esa conversación.
  Future<List<Mensaje>> getMensajesPorConversacion(int conversacionId) async {
    final todos = await _loadAllMensajes();
    return todos.where((m) => m.conversacion_id == conversacionId).toList();
  }

  /// “Guarda” un nuevo mensaje (simulado). Retorna true si “exitoso”.
  Future<bool> guardarMensaje(Mensaje mensaje) async {
    // En entorno real, insertarías en la base de datos. Aquí devolvemos true:
    return true;
  }
}
