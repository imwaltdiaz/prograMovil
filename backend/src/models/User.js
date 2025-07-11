const database = require('../config/database');

class User {
  constructor(data) {
    this.usuario_id = data.usuario_id || data.id;
    this.email = data.email;
    this.password_hash = data.password_hash || data.password;
    this.nombre = data.nombre || data.name;
    this.fecha_registro = data.fecha_registro || data.created_at;
    this.ultimo_acceso = data.ultimo_acceso || data.updated_at;
    this.imagen_url = data.imagen_url;
  }

  // ============================================
  // MÉTODOS DE ACCESO A DATOS (SOLO CRUD)
  // ============================================

  // Crear usuario en BD
  static async create({ nombre, email, password_hash }) {
    const fecha_registro = new Date().toISOString();

    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO usuarios (email, password_hash, nombre, fecha_registro)
        VALUES (?, ?, ?, ?)
      `;

      database.getDb().run(query, [email, password_hash, nombre, fecha_registro], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({
            id: this.lastID,
            usuario_id: this.lastID,
            email,
            nombre,
            fecha_registro
          });
        }
      });
    });
  }

  // Buscar por email
  static async findByEmail(email) {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM usuarios WHERE email = ?`;
      
      database.getDb().get(query, [email], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new User(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Buscar por ID
  static async findById(id) {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM usuarios WHERE usuario_id = ?`;
      
      database.getDb().get(query, [id], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new User(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Actualizar último acceso
  static async updateLastAccess(usuario_id) {
    const ultimo_acceso = new Date().toISOString();
    return new Promise((resolve, reject) => {
      const query = `UPDATE usuarios SET ultimo_acceso = ? WHERE usuario_id = ?`;
      
      database.getDb().run(query, [ultimo_acceso, usuario_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Actualizar imagen de perfil
  static async updateProfileImage(usuario_id, imagen_url) {
    return new Promise((resolve, reject) => {
      const query = `UPDATE usuarios SET imagen_url = ? WHERE usuario_id = ?`;
      
      database.getDb().run(query, [imagen_url, usuario_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Actualizar perfil (nombre y email)
  static async updateProfile(usuario_id, { nombre, email }) {
    return new Promise((resolve, reject) => {
      const query = `UPDATE usuarios SET nombre = ?, email = ? WHERE usuario_id = ?`;
      
      database.getDb().run(query, [nombre, email, usuario_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // ============================================
  // MÉTODOS DE INSTANCIA (SOLO ACCESO A DATOS)
  // ============================================

  // Obtener datos sin contraseña
  getPublicData() {
    return {
      id: this.usuario_id,
      usuario_id: this.usuario_id,
      email: this.email,
      nombre: this.nombre,
      fecha_registro: this.fecha_registro,
      ultimo_acceso: this.ultimo_acceso,
      imagen_url: this.imagen_url
    };
  }
}

module.exports = User;
