class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// Errores comunes predefinidos
class ValidationError extends AppError {
  constructor(message = 'Datos de entrada inválidos') {
    super(message, 400);
  }
}

class AuthenticationError extends AppError {
  constructor(message = 'No autorizado') {
    super(message, 401);
  }
}

class ForbiddenError extends AppError {
  constructor(message = 'Acceso denegado') {
    super(message, 403);
  }
}

class NotFoundError extends AppError {
  constructor(message = 'Recurso no encontrado') {
    super(message, 404);
  }
}

class ConflictError extends AppError {
  constructor(message = 'Conflicto en el recurso') {
    super(message, 409);
  }
}

class DatabaseError extends AppError {
  constructor(message = 'Error en la base de datos') {
    super(message, 500);
  }
}

// Función para manejar errores de manera consistente
const handleAsync = (fn) => {
  return (req, res, next) => {
    fn(req, res, next).catch(next);
  };
};

// Middleware global de manejo de errores
const globalErrorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  // Log del error
  if (process.env.NODE_ENV === 'development') {
    console.error('🚨 Error Details:', {
      message: error.message,
      stack: err.stack,
      url: req.url,
      method: req.method,
      body: req.body,
      params: req.params,
      query: req.query
    });
  } else {
    console.error('🚨 Error:', error.message);
  }

  // Error de validación de express-validator ya manejado en middleware
  if (err.name === 'ValidationError') {
    error = new ValidationError(err.message);
  }

  // Error de JWT
  if (err.name === 'JsonWebTokenError') {
    error = new AuthenticationError('Token inválido');
  }

  if (err.name === 'TokenExpiredError') {
    error = new AuthenticationError('Token expirado');
  }

  // Error de SQLite
  if (err.code === 'SQLITE_CONSTRAINT_UNIQUE') {
    error = new ConflictError('Ya existe un registro con estos datos');
  }

  if (err.code === 'SQLITE_CONSTRAINT_FOREIGNKEY') {
    error = new ValidationError('Referencia inválida en los datos');
  }

  // Respuesta de error
  const statusCode = error.statusCode || 500;
  const response = {
    error: error.status === 'fail' ? 'Error en la solicitud' : 'Error interno del servidor',
    message: error.message
  };

  // En desarrollo, incluir más detalles
  if (process.env.NODE_ENV === 'development') {
    response.stack = err.stack;
  }

  res.status(statusCode).json(response);
};

module.exports = {
  AppError,
  ValidationError,
  AuthenticationError,
  ForbiddenError,
  NotFoundError,
  ConflictError,
  DatabaseError,
  handleAsync,
  globalErrorHandler
};
