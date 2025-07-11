const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const { validateId } = require('../middleware/validation');
const UserPreferenceController = require('../controllers/UserPreferenceController');

const router = express.Router();

// GET /api/preferences - Obtener preferencias del usuario
router.get('/', authenticateToken, UserPreferenceController.getUserPreferences);

// GET /api/preferences/default-model - Obtener modelo por defecto del usuario
router.get('/default-model', authenticateToken, UserPreferenceController.getUserDefaultModel);

// PUT /api/preferences - Actualizar preferencias del usuario
router.put('/', authenticateToken, UserPreferenceController.updateUserPreferences);

// POST /api/preferences/reset - Restablecer preferencias a valores por defecto
router.post('/reset', authenticateToken, UserPreferenceController.resetUserPreferences);

module.exports = router;
