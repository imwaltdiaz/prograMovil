class Conversacion {
  int conversacion_id;
  int usuario_id;
  int modelo_ia_id;
  String titulo;
  DateTime fecha_creacion;
  DateTime ultima_actualizacion;

  Conversacion({
    required this.conversacion_id,
    required this.usuario_id,
    required this.modelo_ia_id,
    required this.titulo,
    required this.fecha_creacion,
    required this.ultima_actualizacion,
  });

  factory Conversacion.fromJson(Map<String, dynamic> json) {
    return Conversacion(
      conversacion_id: json['conversacion_id'] as int,
      usuario_id: json['usuario_id'] as int,
      modelo_ia_id: json['modelo_ia_id'] as int,
      titulo: json['titulo'] as String,
      fecha_creacion: DateTime.parse(json['fecha_creacion'] as String),
      ultima_actualizacion:
          DateTime.parse(json['ultima_actualizacion'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversacion_id': conversacion_id,
      'usuario_id': usuario_id,
      'modelo_ia_id': modelo_ia_id,
      'titulo': titulo,
      'fecha_creacion': fecha_creacion.toUtc().toIso8601String(),
      'ultima_actualizacion': ultima_actualizacion.toUtc().toIso8601String(),
    };
  }
}
