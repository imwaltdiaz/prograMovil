CREATE TABLE modelos_ia (
    modelo_ia_id INTEGER PRIMARY KEY,
    proveedor TEXT NOT NULL,
    nombre TEXT NOT NULL,
    identificador_interno_modelo TEXT NOT NULL,
    activo INTEGER NOT NULL CHECK (activo IN (0, 1))
);