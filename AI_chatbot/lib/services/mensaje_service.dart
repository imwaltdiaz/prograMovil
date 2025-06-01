// lib/services/mensaje_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/mensaje.dart';

class MensajeService {
  Future<List<Mensaje>> getMensajesPorConversacion(int conversacionId) async {
    final jsonData = await rootBundle.loadString('assets/jsons/mensajes.json');
    final Map<String, dynamic> dataMap = json.decode(jsonData);
    final List mensajesJson = dataMap['mensajes'] as List;

    print('>> [MensajeService] total mensajes en JSON: ${mensajesJson.length}');
    final filtro = mensajesJson
        .where((m) => (m['conversacion_id'] as int) == conversacionId);
    print(
        '>> [MensajeService] filtrados para conversacion $conversacionId: ${filtro.length}');

    final List<Mensaje> resultado =
        filtro.map((m) => Mensaje.fromJson(m as Map<String, dynamic>)).toList();

    return resultado;
  }

  Future<void> guardarMensaje(Mensaje mensaje) async {
    // En este mock no escribimos nada en disco, sólo simulamos.
    return;
  }
}
