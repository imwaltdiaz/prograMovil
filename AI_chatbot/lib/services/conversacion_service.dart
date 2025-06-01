// lib/services/conversacion_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/conversacion.dart';

class ConversacionService {
  /// Devuelve la lista de Conversacion para un usuario dado
  Future<List<Conversacion>> getConversacionesPorUsuario(int usuarioId) async {
    final jsonData =
        await rootBundle.loadString('assets/jsons/conversaciones.json');
    final Map<String, dynamic> dataMap = json.decode(jsonData);

    final List convJson = dataMap['conversaciones'] as List;

    final List<Conversacion> resultado = convJson
        .where((c) => (c['usuario_id'] as int) == usuarioId)
        .map((c) => Conversacion.fromJson(c as Map<String, dynamic>))
        .toList();

    return resultado;
  }
}
