const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const User = require('../models/User');

const router = express.Router();

// GET /api/users/profile - Obtener perfil del usuario autenticado
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    console.log('🔍 Profile route - req.user:', req.user);
    
    const user = await User.findById(req.user.id);
    console.log('🔍 User found in DB:', user);
    
    if (!user) {
      return res.status(404).json({
        error: 'Usuario no encontrado',
        message: 'El usuario no existe'
      });
    }

    res.json({
      message: 'Perfil obtenido exitosamente',
      user: {
        usuario_id: user.usuario_id,
        nombre: user.nombre,
        email: user.email,
        fecha_registro: user.fecha_registro
      }
    });

  } catch (error) {
    console.error('Error al obtener perfil:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo obtener el perfil'
    });
  }
});

module.exports = router;
