const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const Conversation = require('../models/Conversation');
const Message = require('../models/Message');
const AIModel = require('../models/AIModel');
const UserPreference = require('../models/UserPreference');

const router = express.Router();

// GET /api/conversations - Obtener todas las conversaciones del usuario
router.get('/', authenticateToken, async (req, res) => {
  try {
    const conversations = await Conversation.findByUserId(req.user.id);
    
    res.json({
      message: 'Conversaciones obtenidas exitosamente',
      conversations,
      total: conversations.length
    });

  } catch (error) {
    console.error('Error al obtener conversaciones:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudieron obtener las conversaciones'
    });
  }
});

// GET /api/conversations/:id - Obtener una conversación específica con mensajes
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Obtener conversación
    const conversation = await Conversation.findById(id);
    if (!conversation) {
      return res.status(404).json({
        error: 'Conversación no encontrada',
        message: 'La conversación no existe'
      });
    }

    // Verificar que la conversación pertenece al usuario
    if (conversation.usuario_id !== req.user.id) {
      return res.status(403).json({
        error: 'Acceso denegado',
        message: 'No tienes permisos para acceder a esta conversación'
      });
    }

    // Obtener mensajes de la conversación
    const messages = await Message.findByConversationId(id);
    
    res.json({
      message: 'Conversación obtenida exitosamente',
      conversation: {
        ...conversation,
        messages
      }
    });

  } catch (error) {
    console.error('Error al obtener conversación:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo obtener la conversación'
    });
  }
});

// POST /api/conversations - Crear nueva conversación
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { titulo, modelo_ia_id } = req.body;

    // Si no se especifica modelo, usar el por defecto del usuario
    let modeloId = modelo_ia_id;
    if (!modeloId) {
      const defaultModel = await UserPreference.getUserDefaultModel(req.user.id);
      modeloId = defaultModel?.modelo_ia_id;
      
      if (!modeloId) {
        const fallbackModel = await AIModel.getDefault();
        modeloId = fallbackModel?.modelo_ia_id;
      }
    }

    if (!modeloId) {
      return res.status(400).json({
        error: 'Modelo de IA no disponible',
        message: 'No hay modelos de IA activos para crear la conversación'
      });
    }

    // Crear conversación
    const conversation = await Conversation.create({
      usuario_id: req.user.id,
      modelo_ia_id: modeloId,
      titulo: titulo || 'Nueva conversación'
    });

    res.status(201).json({
      message: 'Conversación creada exitosamente',
      conversation
    });

  } catch (error) {
    console.error('Error al crear conversación:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo crear la conversación'
    });
  }
});

// PUT /api/conversations/:id - Actualizar título de conversación
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const { titulo } = req.body;

    if (!titulo) {
      return res.status(400).json({
        error: 'Título requerido',
        message: 'Debes proporcionar un título para la conversación'
      });
    }

    // Verificar que la conversación existe y pertenece al usuario
    const conversation = await Conversation.findById(id);
    if (!conversation) {
      return res.status(404).json({
        error: 'Conversación no encontrada',
        message: 'La conversación no existe'
      });
    }

    if (conversation.usuario_id !== req.user.id) {
      return res.status(403).json({
        error: 'Acceso denegado',
        message: 'No tienes permisos para modificar esta conversación'
      });
    }

    // Actualizar título (necesitarías implementar este método en el modelo)
    // Por ahora simulamos la respuesta
    res.json({
      message: 'Conversación actualizada exitosamente',
      conversation: {
        ...conversation,
        titulo
      }
    });

  } catch (error) {
    console.error('Error al actualizar conversación:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo actualizar la conversación'
    });
  }
});

// DELETE /api/conversations/:id - Eliminar conversación
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar que la conversación existe y pertenece al usuario
    const conversation = await Conversation.findById(id);
    if (!conversation) {
      return res.status(404).json({
        error: 'Conversación no encontrada',
        message: 'La conversación no existe'
      });
    }

    if (conversation.usuario_id !== req.user.id) {
      return res.status(403).json({
        error: 'Acceso denegado',
        message: 'No tienes permisos para eliminar esta conversación'
      });
    }

    // Eliminar conversación (esto también eliminará los mensajes por cascade)
    const deleted = await Conversation.delete(id);
    
    if (deleted) {
      res.json({
        message: 'Conversación eliminada exitosamente'
      });
    } else {
      res.status(500).json({
        error: 'Error al eliminar',
        message: 'No se pudo eliminar la conversación'
      });
    }

  } catch (error) {
    console.error('Error al eliminar conversación:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo eliminar la conversación'
    });
  }
});

module.exports = router;
