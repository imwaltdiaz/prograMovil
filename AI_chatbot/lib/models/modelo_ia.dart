// lib/models/modelo_ia.dart

class ModeloIA {
  int modelo_ia_id;
  String proveedor; // <-- Nuevo campo
  String nombre;
  String identificador_interno_modelo;
  bool activo;

  ModeloIA({
    required this.modelo_ia_id,
    required this.proveedor, // <-- Lo añadimos en el constructor
    required this.nombre,
    required this.identificador_interno_modelo,
    required this.activo,
  });

  /// Crea un objeto ModeloIA a partir de un Map (JSON).
  factory ModeloIA.fromJson(Map<String, dynamic> json) {
    return ModeloIA(
      modelo_ia_id: json['modelo_ia_id'] as int,
      proveedor: json['proveedor'] as String, // <-- Nueva línea
      nombre: json['nombre'] as String,
      identificador_interno_modelo:
          json['identificador_interno_modelo'] as String,
      activo: json['activo'] as bool,
    );
  }

  /// Convierte este objeto a Map<String, dynamic> para JSON.
  Map<String, dynamic> toJson() {
    return {
      'modelo_ia_id': modelo_ia_id,
      'proveedor': proveedor, // <-- Nueva línea
      'nombre': nombre,
      'identificador_interno_modelo': identificador_interno_modelo,
      'activo': activo,
    };
  }

  @override
  String toString() {
    return 'ModeloIA(id: $modelo_ia_id, proveedor: $proveedor, '
        'nombre: $nombre, interno: $identificador_interno_modelo, activo: $activo)';
  }
}
