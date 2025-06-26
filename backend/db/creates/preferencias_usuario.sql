CREATE TABLE preferencias_usuario (
    usuario_id INTEGER PRIMARY KEY,
    modelo_ia_default_id INTEGER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (modelo_ia_default_id) REFERENCES modelos_ia(modelo_ia_id)
);