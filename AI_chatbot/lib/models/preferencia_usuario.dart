class PreferenciaUsuario {
  int usuario_id;
  int modelo_ia_default_id;

  PreferenciaUsuario({
    required this.usuario_id,
    required this.modelo_ia_default_id,
  });

  factory PreferenciaUsuario.fromJson(Map<String, dynamic> json) {
    return PreferenciaUsuario(
      usuario_id: json['usuario_id'] as int,
      modelo_ia_default_id: json['modelo_ia_default_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuario_id,
      'modelo_ia_default_id': modelo_ia_default_id,
    };
  }
}
