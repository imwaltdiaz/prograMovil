const express = require('express');
const AuthController = require('../controllers/AuthController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// POST /api/auth/register - Registro de usuario
router.post('/register', AuthController.register);

// POST /api/auth/login - Inicio de sesión
router.post('/login', AuthController.login);

// GET /api/auth/verify - Verificar token
router.get('/verify', authenticateToken, AuthController.verifyToken);

module.exports = router;
