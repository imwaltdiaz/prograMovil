class ModeloIA {
  int modelo_ia_id;
  String nombre;
  String identificador_interno_modelo;
  bool activo;

  ModeloIA({
    required this.modelo_ia_id,
    required this.nombre,
    required this.identificador_interno_modelo,
    required this.activo,
  });

  factory ModeloIA.fromJson(Map<String, dynamic> json) {
    return ModeloIA(
      modelo_ia_id: json['modelo_ia_id'] as int,
      nombre: json['nombre'] as String,
      identificador_interno_modelo:
          json['identificador_interno_modelo'] as String,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelo_ia_id': modelo_ia_id,
      'nombre': nombre,
      'identificador_interno_modelo': identificador_interno_modelo,
      'activo': activo,
    };
  }
}
