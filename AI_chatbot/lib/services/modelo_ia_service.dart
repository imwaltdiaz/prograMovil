// lib/services/modelo_ia_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/modelo_ia.dart';

class ModeloIAService {
  /// Carga todos los modelos IA desde el JSON.
  Future<List<ModeloIA>> getTodosModelosIA() async {
    final raw = await rootBundle.loadString('assets/jsons/modelos_ia.json');
    final Map<String, dynamic> jsonMap =
        json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> listaJson = jsonMap['modelos_ia'] as List<dynamic>;

    // Filtramos solo los que estén activos: active == true
    return listaJson
        .map((m) => ModeloIA.fromJson(m as Map<String, dynamic>))
        .where((m) => m.activo == true)
        .toList();
  }
}
