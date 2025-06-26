const sqlite3 = require('sqlite3').verbose();
const path = require('path');

class Database {
  constructor() {
    this.db = null;
  }

  connect() {
    return new Promise((resolve, reject) => {
      const dbPath = path.join(__dirname, '../../data_base/db.db');
      
      this.db = new sqlite3.Database(dbPath, (err) => {
        if (err) {
          console.error('Error al conectar con la base de datos:', err.message);
          reject(err);
        } else {
          console.log('✅ Conectado a la base de datos SQLite');
          this.initializeTables();
          resolve(this.db);
        }
      });
    });
  }

  initializeTables() {
    // Crear tabla de usuarios
    const createUsersTable = `
      CREATE TABLE IF NOT EXISTS usuarios (
        usuario_id INTEGER PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        nombre TEXT NOT NULL,
        fecha_registro TIMESTAMP NOT NULL,
        ultimo_acceso TIMESTAMP,
        imagen_url TEXT
      )
    `;

    // Crear tabla de modelos de IA
    const createAIModelsTable = `
      CREATE TABLE IF NOT EXISTS modelos_ia (
        modelo_ia_id INTEGER PRIMARY KEY,
        proveedor TEXT NOT NULL,
        nombre TEXT NOT NULL,
        identificador_interno_modelo TEXT NOT NULL,
        activo INTEGER NOT NULL CHECK (activo IN (0, 1)) DEFAULT 1
      )
    `;

    // Crear tabla de conversaciones
    const createConversationsTable = `
      CREATE TABLE IF NOT EXISTS conversaciones (
        conversacion_id INTEGER PRIMARY KEY,
        usuario_id INTEGER NOT NULL,
        modelo_ia_id INTEGER NOT NULL,
        titulo TEXT,
        fecha_creacion TIMESTAMP NOT NULL,
        ultima_actualizacion TIMESTAMP NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
        FOREIGN KEY (modelo_ia_id) REFERENCES modelos_ia(modelo_ia_id)
      )
    `;

    // Crear tabla de mensajes
    const createMessagesTable = `
      CREATE TABLE IF NOT EXISTS mensajes (
        mensaje_id INTEGER PRIMARY KEY,
        conversacion_id INTEGER NOT NULL,
        remitente TEXT NOT NULL CHECK (remitente IN ('user', 'assistant')),
        contenido_texto TEXT NOT NULL,
        timestamp_envio TIMESTAMP NOT NULL,
        FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id)
      )
    `;

    // Crear tabla de preferencias de usuario
    const createUserPreferencesTable = `
      CREATE TABLE IF NOT EXISTS preferencias_usuario (
        usuario_id INTEGER PRIMARY KEY,
        modelo_ia_default_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
        FOREIGN KEY (modelo_ia_default_id) REFERENCES modelos_ia(modelo_ia_id)
      )
    `;

    // Ejecutar las creaciones
    this.db.run(createUsersTable);
    this.db.run(createAIModelsTable);
    this.db.run(createConversationsTable);
    this.db.run(createMessagesTable);
    this.db.run(createUserPreferencesTable);

    // Insertar modelos de IA por defecto si no existen
    this.insertDefaultAIModels();
  }

  insertDefaultAIModels() {
    const defaultModels = [
      {
        proveedor: 'OpenAI',
        nombre: 'GPT-3.5 Turbo',
        identificador_interno_modelo: 'gpt-3.5-turbo',
        activo: 1
      },
      {
        proveedor: 'OpenAI', 
        nombre: 'GPT-4',
        identificador_interno_modelo: 'gpt-4',
        activo: 1
      },
      {
        proveedor: 'Anthropic',
        nombre: 'Claude 3 Haiku',
        identificador_interno_modelo: 'claude-3-haiku-20240307',
        activo: 1
      }
    ];

    defaultModels.forEach(model => {
      const query = `
        INSERT OR IGNORE INTO modelos_ia (proveedor, nombre, identificador_interno_modelo, activo)
        VALUES (?, ?, ?, ?)
      `;
      this.db.run(query, [model.proveedor, model.nombre, model.identificador_interno_modelo, model.activo]);
    });
  }

  getDb() {
    return this.db;
  }

  close() {
    return new Promise((resolve, reject) => {
      if (this.db) {
        this.db.close((err) => {
          if (err) {
            reject(err);
          } else {
            console.log('🔒 Conexión a la base de datos cerrada');
            resolve();
          }
        });
      } else {
        resolve();
      }
    });
  }
}

// Singleton instance
const database = new Database();

module.exports = database;
