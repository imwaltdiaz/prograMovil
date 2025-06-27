const AuthController = require('../controllers/AuthController');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  console.log('🔍 Auth Debug:', {
    authHeader,
    token,
    headers: req.headers
  });

  if (!token) {
    return res.status(401).json({
      error: 'Token de acceso requerido',
      message: 'Debes estar autenticado para acceder a este recurso'
    });
  }

  // Validar token simple
  const userId = AuthController.validateToken(token);
  console.log('🔍 Token validation result:', { token, userId });
  
  if (!userId) {
    return res.status(403).json({
      error: 'Token inválido',
      message: 'El token proporcionado no es válido o ha expirado'
    });
  }

  req.user = { id: userId };
  console.log('🔍 User set in request:', req.user);
  next();
};


const optionalAuth = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token) {
    const userId = AuthController.validateToken(token);
    if (userId) {
      req.user = { id: userId };
    }
  }

  next();
};

module.exports = {
  authenticateToken,
  optionalAuth
};
