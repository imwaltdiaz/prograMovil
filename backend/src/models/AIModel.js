const database = require('../config/database');

class AIModel {
  constructor(data) {
    this.modelo_ia_id = data.modelo_ia_id;
    this.proveedor = data.proveedor;
    this.nombre = data.nombre;
    this.identificador_interno_modelo = data.identificador_interno_modelo;
    this.activo = data.activo;
  }

  // Crear un nuevo modelo de IA
  static async create(modelData) {
    const { proveedor, nombre, identificador_interno_modelo, activo = 1 } = modelData;

    return new Promise((resolve, reject) => {
      const query = `
        INSERT INTO modelos_ia (proveedor, nombre, identificador_interno_modelo, activo)
        VALUES (?, ?, ?, ?)
      `;

      database.getDb().run(query, [proveedor, nombre, identificador_interno_modelo, activo], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({
            modelo_ia_id: this.lastID,
            proveedor,
            nombre,
            identificador_interno_modelo,
            activo
          });
        }
      });
    });
  }

  // Obtener todos los modelos activos
  static async findActive() {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM modelos_ia WHERE activo = 1 ORDER BY proveedor, nombre`;
      
      database.getDb().all(query, [], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new AIModel(row)));
        }
      });
    });
  }

  // Obtener todos los modelos
  static async findAll() {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM modelos_ia ORDER BY proveedor, nombre`;
      
      database.getDb().all(query, [], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new AIModel(row)));
        }
      });
    });
  }

  // Buscar modelo por ID
  static async findById(modelo_ia_id) {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM modelos_ia WHERE modelo_ia_id = ?`;
      
      database.getDb().get(query, [modelo_ia_id], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new AIModel(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // Buscar modelos por proveedor
  static async findByProvider(proveedor) {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM modelos_ia WHERE proveedor = ? AND activo = 1`;
      
      database.getDb().all(query, [proveedor], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows.map(row => new AIModel(row)));
        }
      });
    });
  }

  // Activar/desactivar modelo
  static async updateStatus(modelo_ia_id, activo) {
    return new Promise((resolve, reject) => {
      const query = `UPDATE modelos_ia SET activo = ? WHERE modelo_ia_id = ?`;
      
      database.getDb().run(query, [activo, modelo_ia_id], function(err) {
        if (err) {
          reject(err);
        } else {
          resolve(this.changes > 0);
        }
      });
    });
  }

  // Obtener modelo por defecto (el primer activo)
  static async getDefault() {
    return new Promise((resolve, reject) => {
      const query = `SELECT * FROM modelos_ia WHERE activo = 1 ORDER BY modelo_ia_id LIMIT 1`;
      
      database.getDb().get(query, [], (err, row) => {
        if (err) {
          reject(err);
        } else if (row) {
          resolve(new AIModel(row));
        } else {
          resolve(null);
        }
      });
    });
  }

  // ============================================
  // MÉTODOS DE INSTANCIA (SOLO ACCESO A DATOS)
  // ============================================

  // Verificar si el modelo está activo
  isActive() {
    return this.activo === 1;
  }

  // Obtener datos públicos del modelo
  getPublicData() {
    return {
      modelo_ia_id: this.modelo_ia_id,
      proveedor: this.proveedor,
      nombre: this.nombre,
      identificador_interno_modelo: this.identificador_interno_modelo,
      activo: this.activo === 1
    };
  }
}

module.exports = AIModel;
