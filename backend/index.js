const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const path = require('path');
require('dotenv').config();

// Importar configuración de base de datos
const database = require('./src/config/database');

// Importar rutas
const authRoutes = require('./src/routes/auth');
const userRoutes = require('./src/routes/users');
const chatRoutes = require('./src/routes/chat');
const conversationRoutes = require('./src/routes/conversations');
const messageRoutes = require('./src/routes/messages');
const aiModelRoutes = require('./src/routes/ai-models');
const preferenceRoutes = require('./src/routes/preferences');

// Solo si necesitas OpenAI, descomenta estas líneas:
// const OpenAI = require('openai');
// const client = new OpenAI();

const app = express();
const PORT = process.env.PORT || 3001;

// Middlewares de seguridad
app.use(helmet());

// CORS
const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true,
};
app.use(cors(corsOptions));

// Logging
app.use(morgan('combined'));

// Parseo de JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Archivos estáticos
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Rutas de la API
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/conversations', conversationRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/ai-models', aiModelRoutes);
app.use('/api/preferences', preferenceRoutes);

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({
    message: 'AI Chatbot Backend API',
    version: '1.0.0',
    status: 'running'
  });
});

// Ruta para interactuar con GPT (comentada hasta instalar OpenAI)
/*
app.post('/api/gpt', async (req, res) => {
  try {
    const { input, conversacion_id } = req.body;
    if (!input || !conversacion_id) {
      return res.status(400).json({ error: 'Input and conversation ID are required' });
    }

    // Interactuar con GPT
    const response = await client.responses.create({
      model: 'gpt-4.1',
      input,
    });

    const outputText = response.output_text;

    // Insertar el mensaje en la base de datos
    const timestampEnvio = new Date().toISOString();
    await database.query(
      `INSERT INTO mensajes (conversacion_id, remitente, contenido_texto, timestamp_envio) VALUES (?, ?, ?, ?)`,
      [conversacion_id, 'ia', outputText, timestampEnvio]
    );

    res.json({ output: outputText });
  } catch (error) {
    console.error('Error interacting with GPT:', error);
    res.status(500).json({ error: 'Failed to interact with GPT' });
  }
});
*/

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({
    error: 'Endpoint not found',
    message: `Route ${req.originalUrl} not found`
  });
});

// Manejo de errores globales
app.use((error, req, res, next) => {
  console.error('Error:', error);
  res.status(error.status || 500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? error.message : 'Something went wrong'
  });
});

// Iniciar servidor
async function startServer() {
  try {
    // Conectar a la base de datos
    await database.connect();
    
    // Iniciar servidor HTTP
    app.listen(PORT, () => {
      console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
      console.log(`📱 Entorno: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🔗 URL: http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

startServer();

module.exports = app;