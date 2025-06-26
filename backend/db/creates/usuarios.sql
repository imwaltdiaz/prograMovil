CREATE TABLE usuarios (
    usuario_id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    nombre TEXT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL,
    ultimo_acceso TIMESTAMP,
    imagen_url TEXT
);