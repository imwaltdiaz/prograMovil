const Conversation = require('../models/Conversation');
const Message = require('../models/Message');
const AIModel = require('../models/AIModel');
const UserPreference = require('../models/UserPreference');

class ConversationController {
  // ============================================
  // LÓGICA DE NEGOCIO - OBTENER CONVERSACIONES
  // ============================================
  static async getAll(req, res) {
    try {
      // Solo acceso a datos
      const conversations = await Conversation.findByUserId(req.user.id);
      
      // Lógica de negocio: enriquecer con información adicional
      const enrichedConversations = await Promise.all(
        conversations.map(async (conv) => {
          const messageCount = await Message.countByConversationId(conv.conversacion_id);
          const lastMessage = await ConversationController._getLastMessage(conv.conversacion_id);
          
          return {
            ...conv,
            mensaje_count: messageCount,
            ultimo_mensaje: lastMessage
          };
        })
      );
      
      res.json({
        message: 'Conversaciones obtenidas exitosamente',
        conversations: enrichedConversations,
        total: enrichedConversations.length
      });

    } catch (error) {
      console.error('Error al obtener conversaciones:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener las conversaciones'
      });
    }
  }

  // ============================================
  // LÓGICA DE NEGOCIO - OBTENER CONVERSACIÓN ESPECÍFICA
  // ============================================
  static async getById(req, res) {
    try {
      const { id } = req.params;
      
      // Validación de negocio: ID debe ser número
      if (!ConversationController._isValidId(id)) {
        return res.status(400).json({
          error: 'ID inválido',
          message: 'El ID de la conversación debe ser un número válido'
        });
      }

      // Acceso a datos
      const conversation = await Conversation.findById(id);
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación no existe'
        });
      }

      // Lógica de negocio: verificar pertenencia
      if (!ConversationController._userOwnsConversation(conversation, req.user.id)) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permisos para acceder a esta conversación'
        });
      }

      // Enriquecer con mensajes
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
  }

  // ============================================
  // LÓGICA DE NEGOCIO - CREAR CONVERSACIÓN
  // ============================================
  static async create(req, res) {
    try {
      const { titulo, modelo_ia_id } = req.body;

      // Lógica de negocio: determinar modelo a usar
      const modeloId = await ConversationController._determineModelToUse(modelo_ia_id, req.user.id);
      
      if (!modeloId) {
        return res.status(400).json({
          error: 'Modelo de IA no disponible',
          message: 'No hay modelos de IA activos para crear la conversación'
        });
      }

      // Lógica de negocio: generar título si no se proporciona
      const finalTitle = titulo || ConversationController._generateDefaultTitle();

      // Acceso a datos
      const conversation = await Conversation.create({
        usuario_id: req.user.id,
        modelo_ia_id: modeloId,
        titulo: finalTitle
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
  }

  // ============================================
  // LÓGICA DE NEGOCIO - ACTUALIZAR CONVERSACIÓN
  // ============================================
  static async updateTitle(req, res) {
    try {
      const { id } = req.params;
      const { titulo } = req.body;

      // Validaciones de negocio
      if (!ConversationController._isValidId(id)) {
        return res.status(400).json({
          error: 'ID inválido',
          message: 'El ID de la conversación debe ser un número válido'
        });
      }

      if (!titulo || titulo.trim().length === 0) {
        return res.status(400).json({
          error: 'Título requerido',
          message: 'Debes proporcionar un título válido'
        });
      }

      // Verificar pertenencia
      const conversation = await Conversation.findById(id);
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación no existe'
        });
      }

      if (!ConversationController._userOwnsConversation(conversation, req.user.id)) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permisos para modificar esta conversación'
        });
      }

      // Actualizar título
      const updated = await Conversation.updateTitle(id, titulo.trim());
      
      if (updated) {
        res.json({
          message: 'Título actualizado exitosamente',
          conversation: {
            ...conversation,
            titulo: titulo.trim()
          }
        });
      } else {
        res.status(500).json({
          error: 'Error al actualizar',
          message: 'No se pudo actualizar el título'
        });
      }

    } catch (error) {
      console.error('Error al actualizar conversación:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo actualizar la conversación'
      });
    }
  }

  // ============================================
  // LÓGICA DE NEGOCIO - ELIMINAR CONVERSACIÓN
  // ============================================
  static async delete(req, res) {
    try {
      const { id } = req.params;

      // Validaciones de negocio
      if (!ConversationController._isValidId(id)) {
        return res.status(400).json({
          error: 'ID inválido',
          message: 'El ID de la conversación debe ser un número válido'
        });
      }

      // Verificar pertenencia
      const conversation = await Conversation.findById(id);
      if (!conversation) {
        return res.status(404).json({
          error: 'Conversación no encontrada',
          message: 'La conversación no existe'
        });
      }

      if (!ConversationController._userOwnsConversation(conversation, req.user.id)) {
        return res.status(403).json({
          error: 'Acceso denegado',
          message: 'No tienes permisos para eliminar esta conversación'
        });
      }

      // Lógica de negocio: confirmar si tiene mensajes
      const messageCount = await Message.countByConversationId(id);
      
      // Eliminar conversación (eliminará mensajes en cascada)
      const deleted = await Conversation.delete(id);
      
      if (deleted) {
        res.json({
          message: 'Conversación eliminada exitosamente',
          mensajes_eliminados: messageCount
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
  }

  // ============================================
  // MÉTODOS PRIVADOS (LÓGICA DE NEGOCIO)
  // ============================================

  // Determinar qué modelo usar
  static async _determineModelToUse(requestedModelId, userId) {
    // Si se especifica un modelo, verificar que esté activo
    if (requestedModelId) {
      const model = await AIModel.findById(requestedModelId);
      return (model && model.isActive()) ? requestedModelId : null;
    }

    // Usar modelo por defecto del usuario
    const userDefault = await UserPreference.getUserDefaultModel(userId);
    if (userDefault?.modelo_ia_id) {
      return userDefault.modelo_ia_id;
    }

    // Fallback al modelo por defecto del sistema
    const systemDefault = await AIModel.getDefault();
    return systemDefault?.modelo_ia_id || null;
  }

  // Validar ID
  static _isValidId(id) {
    const numId = parseInt(id);
    return !isNaN(numId) && numId > 0;
  }

  // Verificar si el usuario es dueño de la conversación
  static _userOwnsConversation(conversation, userId) {
    return conversation.usuario_id === userId;
  }

  // Generar título por defecto
  static _generateDefaultTitle() {
    const now = new Date();
    return `Conversación ${now.toLocaleDateString('es-ES')} ${now.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' })}`;
  }

  // Obtener último mensaje de una conversación
  static async _getLastMessage(conversacionId) {
    try {
      const messages = await Message.findByConversationId(conversacionId);
      return messages.length > 0 ? messages[messages.length - 1] : null;
    } catch (error) {
      console.error('Error al obtener último mensaje:', error);
      return null;
    }
  }
}

module.exports = ConversationController;
