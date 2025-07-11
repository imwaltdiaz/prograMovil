const { body, param, query, validationResult } = require('express-validator');

// Middleware para manejar errores de validación
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      error: 'Datos de entrada inválidos',
      message: 'Por favor verifica los datos enviados',
      details: errors.array().map(error => ({
        field: error.path,
        message: error.msg,
        value: error.value
      }))
    });
  }
  next();
};

// Validaciones para autenticación
const validateRegister = [
  body('name')
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('El nombre debe tener entre 2 y 50 caracteres')
    .matches(/^[a-zA-ZÀ-ÿ\s]+$/)
    .withMessage('El nombre solo puede contener letras y espacios'),
  
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Debe ser un email válido'),
  
  body('password')
    .isLength({ min: 6, max: 128 })
    .withMessage('La contraseña debe tener entre 6 y 128 caracteres'),
  
  handleValidationErrors
];

const validateLogin = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Debe ser un email válido'),
  
  body('password')
    .isLength({ min: 1 })
    .withMessage('La contraseña es requerida'),
  
  handleValidationErrors
];

// Validaciones para chat
const validateMessage = [
  body('message')
    .trim()
    .isLength({ min: 1, max: 4000 })
    .withMessage('El mensaje debe tener entre 1 y 4000 caracteres')
    .escape(),
  
  body('conversacion_id')
    .optional()
    .isInt({ min: 1 })
    .withMessage('ID de conversación debe ser un número entero positivo'),
  
  body('modelo_ia_id')
    .optional()
    .isInt({ min: 1 })
    .withMessage('ID de modelo debe ser un número entero positivo'),
  
  handleValidationErrors
];

// Validaciones para conversaciones
const validateConversation = [
  body('titulo')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('El título debe tener entre 1 y 100 caracteres')
    .escape(),
  
  body('modelo_ia_id')
    .optional()
    .isInt({ min: 1 })
    .withMessage('ID de modelo debe ser un número entero positivo'),
  
  handleValidationErrors
];

const validateUpdateConversation = [
  param('id')
    .isInt({ min: 1 })
    .withMessage('ID debe ser un número entero positivo'),
  
  body('titulo')
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('El título debe tener entre 1 y 100 caracteres')
    .escape(),
  
  handleValidationErrors
];

// Validaciones para parámetros de ID
const validateId = [
  param('id')
    .isInt({ min: 1 })
    .withMessage('ID debe ser un número entero positivo'),
  
  handleValidationErrors
];

// Validaciones para parámetros específicos de mensajes
const validateConversationId = [
  param('conversationId')
    .isInt({ min: 1 })
    .withMessage('ID de conversación debe ser un número entero positivo'),
  
  handleValidationErrors
];

const validateMessageId = [
  param('messageId')
    .isInt({ min: 1 })
    .withMessage('ID de mensaje debe ser un número entero positivo'),
  
  handleValidationErrors
];

// Validaciones para paginación
const validatePagination = [
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit debe ser un número entre 1 y 100'),
  
  query('offset')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Offset debe ser un número mayor o igual a 0'),
  
  handleValidationErrors
];

module.exports = {
  handleValidationErrors,
  validateRegister,
  validateLogin,
  validateMessage,
  validateConversation,
  validateUpdateConversation,
  validateId,
  validateConversationId,
  validateMessageId,
  validatePagination
};
