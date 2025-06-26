const database = require('../config/database');

class Conversation {
  constructor(data) {
    this.conversacion_id = data.conversacion_id;
    this.usuario_id = data.usuario_id;
    this.modelo_ia_id = data.modelo_ia_id;
    this.titulo = data.titulo;
    this.fecha_creacion = data.fecha_creacion;
    this.ultima_actualizacion = data.ultima_actualizacion;
    // Campos adicionales de JOIN si están presentes
    this.modelo_nombre = data.modelo_nombre;
    this.proveedor = data.proveedor;
  }

  // ============================================
  // MÉTODOS DE ACCESO A DATOS (SOLO CRUD)
  // ============================================

  // Crear conversación en BD
  static async create({ usuario_id, modelo_ia_id, titulo }) {
    const now = new Date().toISOString();

    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO conversaciones (usuario_id, modelo_ia_id, titulo, fecha_creacion, ultima_actualizacion)
        VALUES (?, ?, ?, ?, ?)
      `;

      database.getDb().run(query, [usuario_id, modelo_ia_id, titulo, now, now], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({
            conversacion_id: this.lastID,
            usuario_id,
            modelo_ia_id,
            titulo,
            fecha_creacion: now,
            ultima_actualizacion: now
          });
        }
      });
    });
  }

  // Buscar conversaciones por usuario
  static async findByUserId(usuario_id) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT c.*, m.nombre as modelo_nombre, m.proveedor 
        FROM conversaciones c
        LEFT JOIN modelos_ia m ON c.modelo_ia_id = m.modelo_ia_id
        WHERE c.usuario_id = ?
        ORDER BY c.ultima_actualizacion DESC
      `;
      
      database.getDb().all(query, [usuario_id], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new Conversation(row)));
        }
      });
    });
  }

  // Buscar conversación por ID
  static async findById(conversacion_id) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT c.*, m.nombre as modelo_nombre, m.proveedor 
        FROM conversaciones c
        LEFT JOIN modelos_ia m ON c.modelo_ia_id = m.modelo_ia_id
        WHERE c.conversacion_id = ?
      `;
      
      database.getDb().get(query, [conversacion_id], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new Conversation(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Actualizar título
  static async updateTitle(conversacion_id, titulo) {
    return new Promise((resolve, reject) => {
      const query = `
        UPDATE conversaciones 
        SET titulo = ?, ultima_actualizacion = ? 
        WHERE conversacion_id = ?
      `;
      
      database.getDb().run(query, [titulo, new Date().toISOString(), conversacion_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Actualizar última actividad
  static async updateLastActivity(conversacion_id) {
    return new Promise((resolve, reject) => {
      const query = `
        UPDATE conversaciones 
        SET ultima_actualizacion = ? 
        WHERE conversacion_id = ?
      `;
      
      database.getDb().run(query, [new Date().toISOString(), conversacion_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Eliminar conversación
  static async delete(conversacion_id) {
    return new Promise((resolve, reject) => {
      // Primero eliminar mensajes relacionados
      const deleteMessages = `DELETE FROM mensajes WHERE conversacion_id = ?`;
      
      database.getDb().run(deleteMessages, [conversacion_id], (err) => {
        if (err) {
          reject(err);
        } else {
          // Luego eliminar la conversación
          const deleteConversation = `DELETE FROM conversaciones WHERE conversacion_id = ?`;
          
          database.getDb().run(deleteConversation, [conversacion_id], function(err) {
            if (err) {
              reject(err);
            } else {
              resolve(this.changes > 0);
            }
          });
        }
      });
    });
  }

  // Contar conversaciones por usuario
  static async countByUserId(usuario_id) {
    return new Promise((resolve, reject) => {
      const query = `SELECT COUNT(*) as count FROM conversaciones WHERE usuario_id = ?`;
      
      database.getDb().get(query, [usuario_id], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row.count);
        }
      });
    });
  }
}

module.exports = Conversation;
