const database = require('../config/database');

class Message {
  constructor(data) {
    this.mensaje_id = data.mensaje_id;
    this.conversacion_id = data.conversacion_id;
    this.remitente = data.remitente; // 'user' o 'assistant'
    this.contenido_texto = data.contenido_texto;
    this.timestamp_envio = data.timestamp_envio;
  }

  // Crear un nuevo mensaje
  static async create(messageData) {
    const { conversacion_id, remitente, contenido_texto } = messageData;
    const timestamp_envio = new Date().toISOString();

    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO mensajes (conversacion_id, remitente, contenido_texto, timestamp_envio)
        VALUES (?, ?, ?, ?)
      `;

      database.getDb().run(query, [conversacion_id, remitente, contenido_texto, timestamp_envio], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({
            mensaje_id: this.lastID,
            conversacion_id,
            remitente,
            contenido_texto,
            timestamp_envio
          });
        }
      });
    });
  }

  // Obtener mensajes de una conversación
  static async findByConversationId(conversacion_id) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT * FROM mensajes 
        WHERE conversacion_id = ? 
        ORDER BY timestamp_envio ASC
      `;
      
      database.getDb().all(query, [conversacion_id], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new Message(row)));
        }
      });
    });
  }

  // Buscar mensaje por ID
  static async findById(mensaje_id) {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM mensajes WHERE mensaje_id = ?`;
      
      database.getDb().get(query, [mensaje_id], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new Message(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Obtener últimos mensajes del usuario
  static async getRecentByUserId(usuario_id, limit = 50) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT m.* FROM mensajes m
        INNER JOIN conversaciones c ON m.conversacion_id = c.conversacion_id
        WHERE c.usuario_id = ?
        ORDER BY m.timestamp_envio DESC
        LIMIT ?
      `;
      
      database.getDb().all(query, [usuario_id, limit], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new Message(row)));
        }
      });
    });
  }

  // Contar mensajes en una conversación
  static async countByConversationId(conversacion_id) {
    return new Promise((resolve, reject) => {
      const query = `SELECT COUNT(*) as count FROM mensajes WHERE conversacion_id = ?`;
      
      database.getDb().get(query, [conversacion_id], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row.count);
        }
      });
    });
  }

  // Eliminar mensaje
  static async delete(mensaje_id) {
    return new Promise((resolve, reject) => {
      const query = `DELETE FROM mensajes WHERE mensaje_id = ?`;
      
      database.getDb().run(query, [mensaje_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }
}

module.exports = Message;
