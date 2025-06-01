class Usuario {
  int usuario_id;
  String email;
  String password_hash;
  String nombre;
  DateTime fecha_registro;
  DateTime? ultimo_acceso;
  String? imagen_url;

  Usuario({
    required this.usuario_id,
    required this.email,
    required this.password_hash,
    required this.nombre,
    required this.fecha_registro,
    this.ultimo_acceso,
    this.imagen_url,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuario_id: json['usuario_id'] as int,
      email: json['email'] as String,
      password_hash: json['password_hash'] as String,
      nombre: json['nombre'] as String,
      fecha_registro: DateTime.parse(json['fecha_registro'] as String),
      ultimo_acceso: json['ultimo_acceso'] != null
          ? DateTime.parse(json['ultimo_acceso'] as String)
          : null,
      imagen_url: json['imagen_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuario_id,
      'email': email,
      'password_hash': password_hash,
      'nombre': nombre,
      'fecha_registro': fecha_registro.toIso8601String(),
      'ultimo_acceso': ultimo_acceso?.toIso8601String(),
      'imagen_url': imagen_url,
    };
  }

  String get fechaRegistroString {
    final d = fecha_registro;
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  String? get ultimoAccesoString {
    if (ultimo_acceso == null) return null;
    final d = ultimo_acceso!;
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
