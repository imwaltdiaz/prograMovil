// lib/models/mensaje.dart

/// Aquí definimos el enum que usamos para el remitente:
enum RemitenteType { usuario, ia }

RemitenteType remitenteTypeFromString(String s) {
  return s == 'ia' ? RemitenteType.ia : RemitenteType.usuario;
}

String remitenteTypeToString(RemitenteType t) {
  return t == RemitenteType.ia ? 'ia' : 'usuario';
}

class Mensaje {
  int mensaje_id;
  int conversacion_id;
  RemitenteType remitente;
  String contenido_texto;
  DateTime timestamp_envio;

  Mensaje({
    required this.mensaje_id,
    required this.conversacion_id,
    required this.remitente,
    required this.contenido_texto,
    required this.timestamp_envio,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      mensaje_id: json['mensaje_id'] as int,
      conversacion_id: json['conversacion_id'] as int,
      remitente: remitenteTypeFromString(json['remitente'] as String),
      contenido_texto: json['contenido_texto'] as String,
      timestamp_envio: DateTime.parse(json['timestamp_envio'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensaje_id': mensaje_id,
      'conversacion_id': conversacion_id,
      'remitente': remitenteTypeToString(remitente),
      'contenido_texto': contenido_texto,
      'timestamp_envio': timestamp_envio.toUtc().toIso8601String(),
    };
  }
}
