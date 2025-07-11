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

  /// Constructor desde JSON (acepta strings en formato 'YYYY-MM-DD' o ISO)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      // Aceptar tanto 'usuario_id' como 'id' para compatibilidad con backend
      usuario_id: (json['usuario_id'] ?? json['id']) as int,
      email: json['email'] as String,
      password_hash: json['password_hash'] ?? '',
      // Aceptar tanto 'nombre' como 'name' para compatibilidad
      nombre: (json['nombre'] ?? json['name']) as String,
      fecha_registro: _parseDate(json['fecha_registro'] as String? ??
          json['created_at'] as String? ??
          DateTime.now().toIso8601String()),
      ultimo_acceso: json['ultimo_acceso'] != null || json['updated_at'] != null
          ? _parseDate((json['ultimo_acceso'] as String?) ??
              (json['updated_at'] as String?) ??
              DateTime.now().toIso8601String())
          : null,
      imagen_url: json['imagen_url'] as String? ?? '',
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
    try {
      // Intentar parsear como ISO 8601 primero
      if (dateStr.contains('T') || dateStr.contains('Z')) {
        return DateTime.parse(dateStr);
      }

      // Si es solo fecha (YYYY-MM-DD), agregar tiempo
      if (dateStr.length == 10) {
        return DateTime.parse('${dateStr}T00:00:00Z');
      }

      // Si tiene formato 'YYYY-MM-DD HH:MM:SS', convertir a ISO
      if (dateStr.length == 19 && dateStr.contains(' ')) {
        return DateTime.parse('${dateStr.replaceAll(' ', 'T')}Z');
      }

      // Fallback: intentar parsear directamente
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Error parseando fecha: $dateStr - $e');
      // Retornar fecha actual como fallback
      return DateTime.now();
    }
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
