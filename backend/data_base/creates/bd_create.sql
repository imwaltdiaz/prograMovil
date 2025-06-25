-- Tabla: modelos_ia
CREATE TABLE modelos_ia (
    modelo_ia_id INTEGER PRIMARY KEY,
    proveedor TEXT NOT NULL,
    nombre TEXT NOT NULL,
    identificador_interno_modelo TEXT NOT NULL,
    activo INTEGER NOT NULL CHECK (activo IN (0, 1))
);

-- Tabla: usuarios
CREATE TABLE usuarios (
    usuario_id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    nombre TEXT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL,
    ultimo_acceso TIMESTAMP,
    imagen_url TEXT
);

-- Tabla: conversaciones
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

-- Tabla: mensajes
CREATE TABLE mensajes (
    mensaje_id INTEGER PRIMARY KEY,
    conversacion_id INTEGER NOT NULL,
    remitente TEXT NOT NULL,
    contenido_texto TEXT NOT NULL,
    timestamp_envio TIMESTAMP NOT NULL,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id)
);

-- Tabla: preferencias_usuario
CREATE TABLE preferencias_usuario (
    usuario_id INTEGER PRIMARY KEY,
    modelo_ia_default_id INTEGER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (modelo_ia_default_id) REFERENCES modelos_ia(modelo_ia_id)
);
