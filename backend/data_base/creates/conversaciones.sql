CREATE TABLE conversaciones (
    conversacion_id INTEGER PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    modelo_ia_id INTEGER NOT NULL,
    titulo TEXT,
    fecha_creacion TIMESTAMP NOT NULL,
    ultima_actualizacion TIMESTAMP NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (modelo_ia_id) REFERENCES modelos_ia(modelo_ia_id)
);