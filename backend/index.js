const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const path = require('path');
require('dotenv').config();

// Importar configuración de base de datos
const database = require('./src/config/database');

// Importar middleware de errores
const { globalErrorHandler } = require('./src/middleware/errorHandler');

// Importar rutas
const authRoutes = require('./src/routes/auth');
const userRoutes = require('./src/routes/users');
const chatRoutes = require('./src/routes/chat');
const conversationRoutes = require('./src/routes/conversations');
const messageRoutes = require('./src/routes/messages');
const aiModelRoutes = require('./src/routes/ai-models');
const preferenceRoutes = require('./src/routes/preferences');

// Importar el servicio de Google GenAI
const { generateContent } = require('./src/services/googleGenAIService');

const app = express();
const PORT = process.env.PORT || 3001;

// Middlewares de seguridad
app.use(helmet());

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutos
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // límite de requests por IP
  message: {
    error: 'Demasiadas solicitudes',
    message: 'Has excedido el límite de solicitudes. Intenta de nuevo más tarde.'
  },
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
});
app.use('/api/', limiter);

// CORS
const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3001'],
  credentials: true,
  optionsSuccessStatus: 200 // Para compatibilidad con navegadores legacy
};
app.use(cors(corsOptions));

// Logging
const logLevel = process.env.LOG_LEVEL || 'combined';
app.use(morgan(logLevel));

// Parseo de JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
// Middleware para manejar text/plain como JSON (temporal para debugging)
app.use('/api/genai', (req, res, next) => {
  if (req.headers['content-type'] === 'text/plain') {
    let data = '';
    req.on('data', chunk => {
      data += chunk;
    });
    req.on('end', () => {
      try {
        req.body = JSON.parse(data);
      } catch (e) {
        req.body = { contents: data };
      }
      next();
    });
  } else {
    next();
  }
});

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

// Endpoint para probar Google GenAI
app.post('/api/genai', async (req, res) => {
  try {
    console.log('📨 Request recibido');
    console.log('📋 Headers:', req.headers);
    console.log('📦 Body completo:', req.body);
    console.log('📦 Body type:', typeof req.body);
    
    const { contents, options = {} } = req.body;
    
    if (!contents) {
      return res.status(400).json({ 
        error: 'El campo contents es requerido.',
        message: 'Debes proporcionar un mensaje para generar contenido.' 
      });
    }

    const response = await generateContent(contents, options);
    res.json({ 
      text: response,
      status: 'success',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error al generar contenido con Google GenAI:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor',
      message: 'No se pudo procesar la solicitud de IA',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// Endpoint para validar la configuración de IA
app.get('/api/genai/status', async (req, res) => {
  try {
    const { validateApiKey } = require('./src/services/googleGenAIService');
    const isValid = await validateApiKey();
    res.json({
      status: isValid ? 'connected' : 'disconnected',
      message: isValid ? 'API de IA funcionando correctamente' : 'Error en la configuración de IA'
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Error verificando el estado de la IA'
    });
  }
});

// Endpoint para obtener modelos disponibles
app.get('/api/genai/models', async (req, res) => {
  try {
    const { getAvailableModels } = require('./src/services/googleGenAIService');
    const models = await getAvailableModels();
    res.json({
      models,
      count: models.length
    });
  } catch (error) {
    res.status(500).json({
      error: 'Error obteniendo modelos disponibles'
    });
  }
});

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({
    message: 'AI Chatbot Backend API',
    version: '1.0.0',
    status: 'running'
  });
});

// Manejo de errores 404
app.use((req, res, next) => {
  res.status(404).json({
    error: 'Endpoint no encontrado',
    message: `La ruta ${req.originalUrl} no existe`
  });
});

// Manejo de errores globales
app.use(globalErrorHandler);

// Iniciar servidor
async function startServer() {
  try {
    // Conectar a la base de datos
    await database.connect();
    
    // Iniciar servidor HTTP
    app.listen(PORT, () => {
      console.log(`Servidor corriendo en puerto ${PORT}`);
      console.log(`Entorno: ${process.env.NODE_ENV || 'development'}`);
      console.log(`URL: http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

startServer();

module.exports = app;