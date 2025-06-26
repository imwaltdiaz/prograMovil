const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const AIModelController = require('../controllers/AIModelController');

const router = express.Router();

// GET /api/ai-models - Obtener todos los modelos activos
router.get('/', AIModelController.getActiveModels);

// GET /api/ai-models/all - Obtener todos los modelos (requiere autenticación)
router.get('/all', authenticateToken, AIModelController.getAllModels);

// GET /api/ai-models/default - Obtener modelo por defecto
router.get('/default', AIModelController.getDefaultModel);

// GET /api/ai-models/provider/:provider - Obtener modelos por proveedor
router.get('/provider/:provider', AIModelController.getModelsByProvider);

// GET /api/ai-models/:id - Obtener modelo específico
router.get('/:id', AIModelController.getModelById);

// GET /api/ai-models/:id/status - Verificar estado del modelo
router.get('/:id/status', AIModelController.checkModelStatus);

module.exports = router;
