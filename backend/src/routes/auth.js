const express = require('express');
const AuthController = require('../controllers/AuthController');
const { authenticateToken } = require('../middleware/auth');
const { validateRegister, validateLogin } = require('../middleware/validation');

const router = express.Router();

// POST /api/auth/register - Registro de usuario
router.post('/register', validateRegister, AuthController.register);

// POST /api/auth/login - Inicio de sesión
router.post('/login', validateLogin, AuthController.login);

// GET /api/auth/verify - Verificar token
router.get('/verify', authenticateToken, AuthController.verifyToken);

module.exports = router;
