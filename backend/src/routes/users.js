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

// PUT /api/users/profile - Actualizar perfil del usuario autenticado
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    const { nombre, email } = req.body;
    
    // Validaciones básicas
    if (!nombre || !email) {
      return res.status(400).json({
        error: 'Datos incompletos',
        message: 'Nombre y email son requeridos'
      });
    }

    // Verificar que el email no esté siendo usado por otro usuario
    const existingUser = await User.findByEmail(email);
    if (existingUser && existingUser.usuario_id !== req.user.id) {
      return res.status(409).json({
        error: 'Email ya existe',
        message: 'Este email ya está siendo usado por otro usuario'
      });
    }

    // Actualizar el usuario
    const updated = await User.updateProfile(req.user.id, { nombre, email });
    
    if (!updated) {
      return res.status(404).json({
        error: 'Usuario no encontrado',
        message: 'No se pudo actualizar el perfil'
      });
    }

    // Obtener el usuario actualizado
    const user = await User.findById(req.user.id);

    res.json({
      message: 'Perfil actualizado exitosamente',
      user: {
        usuario_id: user.usuario_id,
        nombre: user.nombre,
        email: user.email,
        fecha_registro: user.fecha_registro
      }
    });

  } catch (error) {
    console.error('Error al actualizar perfil:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo actualizar el perfil'
    });
  }
});

module.exports = router;
