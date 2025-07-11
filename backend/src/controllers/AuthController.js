const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/User');

class AuthController {
  // ============================================
  // LÓGICA DE NEGOCIO - REGISTRO
  // ============================================
  static async register(req, res) {
    try {
      const { name, email, password } = req.body;

      // Validaciones de negocio
      const validationError = AuthController._validateRegistrationData({ name, email, password });
      if (validationError) {
        return res.status(400).json(validationError);
      }

      // Verificar si el usuario ya existe
      const existingUser = await User.findByEmail(email);
      if (existingUser) {
        return res.status(409).json({
          error: 'Usuario ya existe',
          message: 'Ya existe un usuario con este email'
        });
      }

      // Hash de la contraseña (lógica de negocio)
      const saltRounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
      const password_hash = await bcrypt.hash(password, saltRounds);

      // Crear usuario (solo acceso a datos)
      const newUser = await User.create({ 
        nombre: name, 
        email, 
        password_hash 
      });

      // Generar token (lógica de negocio)
      const token = AuthController._generateToken(newUser);

      res.status(201).json({
        message: 'Usuario registrado exitosamente',
        user: newUser,
        token
      });

    } catch (error) {
      console.error('Error en registro:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo registrar el usuario'
      });
    }
  }

  // ============================================
  // LÓGICA DE NEGOCIO - LOGIN
  // ============================================
  static async login(req, res) {
    try {
      const { email, password } = req.body;

      // Validaciones de negocio
      if (!email || !password) {
        return res.status(400).json({
          error: 'Datos incompletos',
          message: 'Email y contraseña son requeridos'
        });
      }

      // Buscar usuario
      const user = await User.findByEmail(email);
      if (!user) {
        return res.status(401).json({
          error: 'Credenciales inválidas',
          message: 'Email o contraseña incorrectos'
        });
      }

      // Verificar contraseña (lógica de negocio)
      const isValidPassword = await bcrypt.compare(password, user.password_hash);
      if (!isValidPassword) {
        return res.status(401).json({
          error: 'Credenciales inválidas',
          message: 'Email o contraseña incorrectos'
        });
      }

      // Actualizar último acceso (lógica de negocio)
      await User.updateLastAccess(user.usuario_id);

      // Generar token (lógica de negocio)
      const token = AuthController._generateToken(user);

      res.json({
        message: 'Inicio de sesión exitoso',
        user: user.getPublicData(),
        token
      });

    } catch (error) {
      console.error('Error en login:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo iniciar sesión'
      });
    }
  }

  // ============================================
  // LÓGICA DE NEGOCIO - VERIFICAR TOKEN
  // ============================================
  static async verifyToken(req, res) {
    try {
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({
          error: 'Usuario no encontrado',
          message: 'El usuario asociado al token no existe'
        });
      }

      res.json({
        message: 'Token válido',
        user: user.toJSON()
      });

    } catch (error) {
      console.error('Error en verificación de token:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo verificar el token'
      });
    }
  }

  // ============================================
  // MÉTODOS PRIVADOS (LÓGICA DE NEGOCIO)
  // ============================================

  // Validar datos de registro
  static _validateRegistrationData({ name, email, password }) {
    if (!name || !email || !password) {
      return {
        error: 'Datos incompletos',
        message: 'Nombre, email y contraseña son requeridos'
      };
    }

    if (password.length < 6) {
      return {
        error: 'Contraseña muy corta',
        message: 'La contraseña debe tener al menos 6 caracteres'
      };
    }

    // Validar formato de email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return {
        error: 'Email inválido',
        message: 'El formato del email no es válido'
      };
    }

    return null; // Sin errores
  }

  // Generar token JWT
  static _generateToken(user) {
    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      throw new Error('JWT_SECRET no está configurado en las variables de entorno');
    }

    const payload = {
      userId: user.usuario_id || user.id,
      email: user.email
    };
    
    const token = jwt.sign(
      payload, 
      jwtSecret,
      { 
        expiresIn: '24h',
        issuer: 'ai-chatbot-backend'
      }
    );
    
    console.log(`🔑 Token JWT generado para usuario ${user.email || payload.userId}`);
    return token;
  }

  // Validar token JWT
  static validateToken(token) {
    try {
      const jwtSecret = process.env.JWT_SECRET;
      if (!jwtSecret) {
        console.log('❌ JWT_SECRET no configurado');
        return null;
      }

      const decoded = jwt.verify(token, jwtSecret);
      return decoded.userId;
    } catch (error) {
      console.log('❌ Token inválido:', error.message);
      return null;
    }
  }

  // Limpiar token (no necesario con JWT, pero mantenemos por compatibilidad)
  static removeToken(token) {
    // Con JWT no necesitamos eliminar tokens del servidor
    console.log('🗑️ Token eliminado (logout)');
  }
}

module.exports = AuthController;
