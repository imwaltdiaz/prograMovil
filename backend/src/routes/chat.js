const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const { validateMessage, validateId, validatePagination } = require('../middleware/validation');
const Conversation = require('../models/Conversation');
const Message = require('../models/Message');
const UserPreference = require('../models/UserPreference');
const AIModel = require('../models/AIModel');

const router = express.Router();

// POST /api/chat/message - Enviar mensaje al chatbot
router.post('/message', authenticateToken, validateMessage, async (req, res) => {
  try {
    const { message, conversacion_id, modelo_ia_id } = req.body;

    if (!message) {
      return res.status(400).json({
        error: 'Mensaje requerido',
        message: 'Debes enviar un mensaje'
      });
    }

    let currentConversationId = conversacion_id;

    // Si no hay conversación, crear una nueva
    if (!currentConversationId) {
      let modeloId = modelo_ia_id;
      
      // Si no se especifica modelo, usar el por defecto del usuario
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
          message: 'No hay modelos de IA activos para procesar el mensaje'
        });
      }

      // Crear nueva conversación
      const conversation = await Conversation.create({
        usuario_id: req.user.id,
        modelo_ia_id: modeloId,
        titulo: message.substring(0, 50) + '...' // Usar el inicio del mensaje como título
      });

      currentConversationId = conversation.conversacion_id;
    } else {
      // Verificar que la conversación existe y pertenece al usuario
      const conversation = await Conversation.findById(currentConversationId);
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación especificada no existe'
        });
      }

      if (conversation.usuario_id !== req.user.id) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permisos para enviar mensajes a esta conversación'
        });
      }
    }

    // Crear mensaje del usuario
    const userMessage = await Message.create({
      conversacion_id: currentConversationId,
      remitente: 'user',
      contenido_texto: message
    });

    // Actualizar actividad de la conversación
    await Conversation.updateLastActivity(currentConversationId);

    // Aquí implementarías la lógica del chatbot con IA real
    // Por ahora, una respuesta simple
    const botResponse = `Recibí tu mensaje: "${message}". Esta es una respuesta de prueba del chatbot. En el futuro aquí se integrará con modelos de IA como GPT o Claude.`;
    
    const assistantMessage = await Message.create({
      conversacion_id: currentConversationId,
      remitente: 'assistant',
      contenido_texto: botResponse
    });

    res.json({
      message: 'Mensaje procesado exitosamente',
      conversacion_id: currentConversationId,
      userMessage,
      assistantMessage,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error en chat:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo procesar el mensaje'
    });
  }
});

// GET /api/chat/history - Obtener historial de conversaciones
router.get('/history', authenticateToken, validatePagination, async (req, res) => {
  try {
    const { limit = 10, offset = 0 } = req.query;
    
    // Obtener conversaciones del usuario
    const conversations = await Conversation.findByUserId(req.user.id);
    
    // Aplicar paginación
    const paginatedConversations = conversations.slice(
      parseInt(offset), 
      parseInt(offset) + parseInt(limit)
    );

    // Para cada conversación, obtener algunos mensajes recientes
    const conversationsWithMessages = await Promise.all(
      paginatedConversations.map(async (conv) => {
        const messages = await Message.findByConversationId(conv.conversacion_id);
        return {
          ...conv,
          mensajes_count: messages.length,
          ultimo_mensaje: messages[messages.length - 1] || null
        };
      })
    );

    res.json({
      message: 'Historial obtenido exitosamente',
      conversations: conversationsWithMessages,
      total: conversations.length,
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

  } catch (error) {
    console.error('Error al obtener historial:', error);
    res.status(500).json({
      error: 'Error interno del servidor',
      message: 'No se pudo obtener el historial'
    });
  }
});

// GET /api/chat/conversation/:id - Obtener conversación completa con mensajes
router.get('/conversation/:id', authenticateToken, validateId, async (req, res) => {
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

    // Verificar que pertenece al usuario
    if (conversation.usuario_id !== req.user.id) {
      return res.status(403).json({
        error: 'Acceso denegado',
        message: 'No tienes permisos para acceder a esta conversación'
      });
    }

    // Obtener mensajes
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

module.exports = router;
