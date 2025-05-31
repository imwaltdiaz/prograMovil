class Usuario {
  int usuario_id;
  String email;
  String password_hash;
  String nombre;
  DateTime fecha_registro; // Internamente sigue siendo DateTime
  DateTime? ultimo_acceso;

  Usuario({
    required this.usuario_id,
    required this.email,
    required this.password_hash,
    required this.nombre,
    required this.fecha_registro,
    this.ultimo_acceso,
  });

  // Constructor desde JSON (acepta strings en formato 'YYYY-MM-DD')
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuario_id: json['usuario_id'],
      email: json['email'],
      password_hash: json['password_hash'],
      nombre: json['nombre'],
      fecha_registro: _parseDate(json['fecha_registro']),
      ultimo_acceso: json['ultimo_acceso'] != null
          ? _parseDate(json['ultimo_acceso'])
          : null,
    );
  }

  // Convertir a JSON (devuelve strings en formato 'YYYY-MM-DD')
  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuario_id,
      'email': email,
      'password_hash': password_hash,
      'nombre': nombre,
      'fecha_registro': _formatDate(fecha_registro),
      'ultimo_acceso':
          ultimo_acceso != null ? _formatDate(ultimo_acceso!) : null,
    };
  }

  // Métodos helpers para el formato de fecha
  static DateTime _parseDate(String dateStr) {
    return DateTime.parse('$dateStr 00:00:00Z'); // Añade hora midnight UTC
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'Usuario(usuario_id: $usuario_id, email: $email, nombre: $nombre, '
        'fecha_registro: ${_formatDate(fecha_registro)}, '
        'ultimo_acceso: ${ultimo_acceso != null ? _formatDate(ultimo_acceso!) : null})';
  }
}
