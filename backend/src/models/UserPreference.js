const database = require('../config/database');

class UserPreference {
  constructor(data) {
    this.usuario_id = data.usuario_id;
    this.modelo_ia_default_id = data.modelo_ia_default_id;
  }

  // Crear preferencias de usuario
  static async create(usuario_id, modelo_ia_default_id) {
    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO preferencias_usuario (usuario_id, modelo_ia_default_id)
        VALUES (?, ?)
      `;

      database.getDb().run(query, [usuario_id, modelo_ia_default_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({
            usuario_id,
            modelo_ia_default_id
          });
        }
      });
    });
  }

  // Obtener preferencias por usuario
  static async findByUserId(usuario_id) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT p.*, m.nombre as modelo_nombre, m.proveedor 
        FROM preferencias_usuario p
        LEFT JOIN modelos_ia m ON p.modelo_ia_default_id = m.modelo_ia_id
        WHERE p.usuario_id = ?
      `;
      
      database.getDb().get(query, [usuario_id], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new UserPreference(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Actualizar modelo por defecto del usuario
  static async updateDefaultModel(usuario_id, modelo_ia_default_id) {
    return new Promise((resolve, reject) => {
      const query = `
        UPDATE preferencias_usuario 
        SET modelo_ia_default_id = ? 
        WHERE usuario_id = ?
      `;
      
      database.getDb().run(query, [modelo_ia_default_id, usuario_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Obtener el modelo por defecto del usuario (con fallback)
  static async getUserDefaultModel(usuario_id) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT m.* FROM modelos_ia m
        LEFT JOIN preferencias_usuario p ON m.modelo_ia_id = p.modelo_ia_default_id
        WHERE (p.usuario_id = ? OR p.usuario_id IS NULL) AND m.activo = 1
        ORDER BY p.usuario_id DESC, m.modelo_ia_id ASC
        LIMIT 1
      `;
      
      database.getDb().get(query, [usuario_id], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row);
        }
      });
    });
  }
}

module.exports = UserPreference;
