// lib/services/mensaje_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/mensaje.dart';

class MensajeService {
  /// Carga todos los mensajes del JSON y filtra por el conversacion_id
  Future<List<Mensaje>> getMensajesPorConversacion(int conversacionId) async {
    // 1) Leer el JSON completo de mensajes
    final jsonData = await rootBundle.loadString('assets/jsons/mensajes.json');
    final Map<String, dynamic> dataMap = json.decode(jsonData);

    // 2) Tomar la lista de objetos “mensajes”
    final List mensajesJson = dataMap['mensajes'] as List;

    // 3) Filtrar sólo aquellos cuyo campo “conversacion_id” coincida
    final List<Mensaje> resultado = mensajesJson
        .where((m) => (m['conversacion_id'] as int) == conversacionId)
        .map((m) => Mensaje.fromJson(m as Map<String, dynamic>))
        .toList();

    return resultado;
  }

  /// En este mock, simplemente devolvemos true. (No reescribimos JSON real.)
  Future<void> guardarMensaje(Mensaje mensaje) async {
    // En un backend real harías un POST o modificarías la base de datos.
    // Aquí no hacemos nada, sólo simulamos que “se guardó”.
    return;
  }
}
