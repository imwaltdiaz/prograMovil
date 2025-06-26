const Message = require('../models/Message');
const Conversation = require('../models/Conversation');

class MessageController {
  // ============================================
  // LÓGICA DE NEGOCIO - MENSAJES
  // ============================================
  
  // Obtener mensajes de una conversación
  static async getConversationMessages(req, res) {
    try {
      const { conversationId } = req.params;
      const usuario_id = req.user.userId;

      // Validaciones de negocio
      if (!conversationId || isNaN(conversationId)) {
        return res.status(400).json({
          error: 'ID de conversación inválido',
          message: 'Se requiere un ID de conversación válido'
        });
      }

      // Verificar que la conversación existe y pertenece al usuario
      const conversation = await Conversation.findById(parseInt(conversationId));
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación especificada no existe'
        });
      }

      if (conversation.usuario_id !== usuario_id) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permiso para acceder a esta conversación'
        });
      }

      // Obtener mensajes
      const messages = await Message.findByConversationId(parseInt(conversationId));

      res.json({
        message: 'Mensajes obtenidos exitosamente',
        conversation_id: parseInt(conversationId),
        message_count: messages.length,
        messages: messages.map(msg => ({
          mensaje_id: msg.mensaje_id,
          conversacion_id: msg.conversacion_id,
          remitente: msg.remitente,
          contenido_texto: msg.contenido_texto,
          timestamp_envio: msg.timestamp_envio
        }))
      });

    } catch (error) {
      console.error('Error obteniendo mensajes de conversación:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener los mensajes'
      });
    }
  }

  // Crear un nuevo mensaje
  static async createMessage(req, res) {
    try {
      const { conversationId } = req.params;
      const { remitente, contenido_texto } = req.body;
      const usuario_id = req.user.userId;

      // Validaciones de negocio
      if (!conversationId || isNaN(conversationId)) {
        return res.status(400).json({
          error: 'ID de conversación inválido',
          message: 'Se requiere un ID de conversación válido'
        });
      }

      if (!remitente || !contenido_texto) {
        return res.status(400).json({
          error: 'Datos incompletos',
          message: 'Remitente y contenido son requeridos'
        });
      }

      if (!['user', 'assistant'].includes(remitente)) {
        return res.status(400).json({
          error: 'Remitente inválido',
          message: 'El remitente debe ser "user" o "assistant"'
        });
      }

      if (contenido_texto.trim().length === 0) {
        return res.status(400).json({
          error: 'Contenido vacío',
          message: 'El mensaje no puede estar vacío'
        });
      }

      // Verificar que la conversación existe y pertenece al usuario
      const conversation = await Conversation.findById(parseInt(conversationId));
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación especificada no existe'
        });
      }

      if (conversation.usuario_id !== usuario_id) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permiso para enviar mensajes a esta conversación'
        });
      }

      // Crear mensaje
      const newMessage = await Message.create({
        conversacion_id: parseInt(conversationId),
        remitente: remitente.trim(),
        contenido_texto: contenido_texto.trim()
      });

      // Lógica de negocio: actualizar la última actividad de la conversación
      await Conversation.updateLastActivity(parseInt(conversationId));

      res.status(201).json({
        message: 'Mensaje creado exitosamente',
        data: {
          mensaje_id: newMessage.mensaje_id,
          conversacion_id: newMessage.conversacion_id,
          remitente: newMessage.remitente,
          contenido_texto: newMessage.contenido_texto,
          timestamp_envio: newMessage.timestamp_envio
        }
      });

    } catch (error) {
      console.error('Error creando mensaje:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo crear el mensaje'
      });
    }
  }

  // Obtener mensajes recientes del usuario
  static async getUserRecentMessages(req, res) {
    try {
      const usuario_id = req.user.userId;
      const { limit } = req.query;

      // Validación y lógica de negocio para el límite
      let messageLimit = 50; // por defecto
      if (limit) {
        const parsedLimit = parseInt(limit);
        if (isNaN(parsedLimit) || parsedLimit < 1) {
          return res.status(400).json({
            error: 'Límite inválido',
            message: 'El límite debe ser un número positivo'
          });
        }
        if (parsedLimit > 200) {
          return res.status(400).json({
            error: 'Límite excedido',
            message: 'El límite máximo es 200 mensajes'
          });
        }
        messageLimit = parsedLimit;
      }

      const messages = await Message.getRecentByUserId(usuario_id, messageLimit);

      res.json({
        message: 'Mensajes recientes obtenidos exitosamente',
        user_id: usuario_id,
        limit: messageLimit,
        message_count: messages.length,
        messages: messages.map(msg => ({
          mensaje_id: msg.mensaje_id,
          conversacion_id: msg.conversacion_id,
          remitente: msg.remitente,
          contenido_texto: msg.contenido_texto,
          timestamp_envio: msg.timestamp_envio
        }))
      });

    } catch (error) {
      console.error('Error obteniendo mensajes recientes:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener los mensajes recientes'
      });
    }
  }

  // Obtener estadísticas de mensajes de una conversación
  static async getConversationStats(req, res) {
    try {
      const { conversationId } = req.params;
      const usuario_id = req.user.userId;

      // Validaciones de negocio
      if (!conversationId || isNaN(conversationId)) {
        return res.status(400).json({
          error: 'ID de conversación inválido',
          message: 'Se requiere un ID de conversación válido'
        });
      }

      // Verificar que la conversación existe y pertenece al usuario
      const conversation = await Conversation.findById(parseInt(conversationId));
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación especificada no existe'
        });
      }

      if (conversation.usuario_id !== usuario_id) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permiso para acceder a esta conversación'
        });
      }

      // Obtener estadísticas
      const totalMessages = await Message.countByConversationId(parseInt(conversationId));

      res.json({
        message: 'Estadísticas obtenidas exitosamente',
        conversation_id: parseInt(conversationId),
        conversation_title: conversation.titulo,
        stats: {
          total_messages: totalMessages,
          created_date: conversation.fecha_creacion,
          last_activity: conversation.ultima_actualizacion
        }
      });

    } catch (error) {
      console.error('Error obteniendo estadísticas de conversación:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener las estadísticas'
      });
    }
  }

  // Eliminar un mensaje
  static async deleteMessage(req, res) {
    try {
      const { messageId } = req.params;
      const usuario_id = req.user.userId;

      // Validaciones de negocio
      if (!messageId || isNaN(messageId)) {
        return res.status(400).json({
          error: 'ID de mensaje inválido',
          message: 'Se requiere un ID de mensaje válido'
        });
      }

      // Verificar que el mensaje existe
      const message = await Message.findById(parseInt(messageId));
      if (!message) {
        return res.status(404).json({
          error: 'Mensaje no encontrado',
          message: 'El mensaje especificado no existe'
        });
      }

      // Verificar que la conversación pertenece al usuario
      const conversation = await Conversation.findById(message.conversacion_id);
      if (!conversation || conversation.usuario_id !== usuario_id) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permiso para eliminar este mensaje'
        });
      }

      // Eliminar mensaje
      const deleted = await Message.delete(parseInt(messageId));
      
      if (!deleted) {
        return res.status(500).json({
          error: 'Error eliminando mensaje',
          message: 'No se pudo eliminar el mensaje'
        });
      }

      res.json({
        message: 'Mensaje eliminado exitosamente',
        deleted_message_id: parseInt(messageId)
      });

    } catch (error) {
      console.error('Error eliminando mensaje:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo eliminar el mensaje'
      });
    }
  }
}

module.exports = MessageController;
