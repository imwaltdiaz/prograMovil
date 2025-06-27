const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const MessageController = require('../controllers/MessageController');

const router = express.Router();

// POST /api/messages - Crear nuevo mensaje
router.post('/', authenticateToken, MessageController.createMessage);

// GET /api/messages/conversation/:conversationId - Obtener mensajes de una conversación
router.get('/conversation/:conversationId', authenticateToken, MessageController.getConversationMessages);

// GET /api/messages/recent - Obtener mensajes recientes del usuario
router.get('/recent', authenticateToken, MessageController.getUserRecentMessages);

// GET /api/messages/conversation/:conversationId/stats - Obtener estadísticas de conversación
router.get('/conversation/:conversationId/stats', authenticateToken, MessageController.getConversationStats);

// DELETE /api/messages/:messageId - Eliminar mensaje
router.delete('/:messageId', authenticateToken, MessageController.deleteMessage);

module.exports = router;
