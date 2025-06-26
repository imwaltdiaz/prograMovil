CREATE TABLE mensajes (
    mensaje_id INTEGER PRIMARY KEY,
    conversacion_id INTEGER NOT NULL,
    remitente TEXT NOT NULL,
    contenido_texto TEXT NOT NULL,
    timestamp_envio TIMESTAMP NOT NULL,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id)
);