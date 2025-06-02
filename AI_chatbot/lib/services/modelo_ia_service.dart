// lib/services/modelo_ia_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/modelo_ia.dart';

class ModeloIAService {
  /// Lee todos los modelos IA del JSON
  Future<List<ModeloIA>> getTodosModelosIA() async {
    // 1) Cargar el JSON (assets/jsons/modelos_ia.json)
    final rawJson = await rootBundle.loadString('assets/jsons/modelos_ia.json');
    final Map<String, dynamic> dataMap =
        json.decode(rawJson) as Map<String, dynamic>;

    // 2) Obtiene la lista cruda del array "modelos_ia"
    final List<dynamic> listaCruda = dataMap['modelos_ia'] as List<dynamic>;

    // 3) Mapear cada entrada a un ModeloIA usando fromJson
    return listaCruda
        .map((item) => ModeloIA.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Devuelve solo los modelos activos
  Future<List<ModeloIA>> getModelosActivos() async {
    final all = await getTodosModelosIA();
    return all.where((m) => m.activo).toList();
  }

  /// Devuelve solo los modelos activos para un proveedor dado
  Future<List<ModeloIA>> getModelosPorProveedor(String proveedor) async {
    final activos = await getModelosActivos();
    // Comparar en minúsculas para evitar problemas de mayúsculas/minúsculas
    return activos
        .where((m) => m.proveedor.toLowerCase() == proveedor.toLowerCase())
        .toList();
  }
}
