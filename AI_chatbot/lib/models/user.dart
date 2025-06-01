// lib/models/user.dart

class Usuario {
  int usuario_id;
  String email;
  String password_hash;
  String nombre;
  DateTime fecha_registro;
  DateTime? ultimo_acceso;
  String imagen_url; // ← NUEVO campo

  Usuario({
    required this.usuario_id,
    required this.email,
    required this.password_hash,
    required this.nombre,
    required this.fecha_registro,
    this.ultimo_acceso,
    required this.imagen_url, // ← requerido
  });

  /// Constructor desde JSON (acepta strings en formato 'YYYY-MM-DD')
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuario_id: json['usuario_id'] as int,
      email: json['email'] as String,
      password_hash: json['password_hash'] as String,
      nombre: json['nombre'] as String,
      fecha_registro: _parseDate(json['fecha_registro'] as String),
      ultimo_acceso: json['ultimo_acceso'] != null
          ? _parseDate(json['ultimo_acceso'] as String)
          : null,
      imagen_url: json['imagen_url'] as String? ?? '',
      // Si el JSON no trajera "imagen_url", lo dejamos cadena vacía
    );
  }

  /// Convierte a JSON (devuelve strings en formato 'YYYY-MM-DD')
  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuario_id,
      'email': email,
      'password_hash': password_hash,
      'nombre': nombre,
      'fecha_registro': _formatDate(fecha_registro),
      'ultimo_acceso':
          ultimo_acceso != null ? _formatDate(ultimo_acceso!) : null,
      'imagen_url': imagen_url,
    };
  }

  // Getter público que devuelve la fecha de registro como "YYYY-MM-DD"
  String get fechaRegistroString => _formatDate(fecha_registro);

  // Getter público para último acceso si quieres mostrarlo
  String? get ultimoAccesoString =>
      ultimo_acceso != null ? _formatDate(ultimo_acceso!) : null;

  // Métodos helpers privados para parsear/formatar
  static DateTime _parseDate(String dateStr) {
    return DateTime.parse('$dateStr 00:00:00Z');
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  String toString() {
    return 'Usuario(usuario_id: $usuario_id, email: $email, nombre: $nombre, '
        'fecha_registro: ${_formatDate(fecha_registro)}, '
        'ultimo_acceso: ${ultimo_acceso != null ? _formatDate(ultimo_acceso!) : null}, '
        'imagen_url: $imagen_url)';
  }
}
