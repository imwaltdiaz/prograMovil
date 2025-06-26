const UserPreference = require('../models/UserPreference');
const AIModel = require('../models/AIModel');

class UserPreferenceController {
  // ============================================
  // LÓGICA DE NEGOCIO - PREFERENCIAS
  // ============================================
  
  // Obtener preferencias del usuario
  static async getUserPreferences(req, res) {
    try {
      const usuario_id = req.user.userId;

      const preferences = await UserPreference.findByUserId(usuario_id);
      
      if (!preferences) {
        return res.status(404).json({
          error: 'Preferencias no encontradas',
          message: 'El usuario no tiene preferencias configuradas'
        });
      }

      res.json({
        message: 'Preferencias obtenidas exitosamente',
        preferences: {
          usuario_id: preferences.usuario_id,
          modelo_ia_default_id: preferences.modelo_ia_default_id,
          modelo_nombre: preferences.modelo_nombre,
          proveedor: preferences.proveedor
        }
      });

    } catch (error) {
      console.error('Error obteniendo preferencias:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener las preferencias'
      });
    }
  }

  // Crear o actualizar preferencias (lógica de negocio upsert)
  static async updateUserPreferences(req, res) {
    try {
      const usuario_id = req.user.userId;
      const { modelo_ia_default_id } = req.body;

      // Validaciones de negocio
      if (!modelo_ia_default_id || isNaN(modelo_ia_default_id)) {
        return res.status(400).json({
          error: 'Datos inválidos',
          message: 'Se requiere un ID de modelo válido'
        });
      }

      // Verificar que el modelo existe y está activo
      const model = await AIModel.findById(parseInt(modelo_ia_default_id));
      if (!model) {
        return res.status(404).json({
          error: 'Modelo no encontrado',
          message: 'El modelo especificado no existe'
        });
      }

      if (model.activo !== 1) {
        return res.status(400).json({
          error: 'Modelo inactivo',
          message: 'No se puede seleccionar un modelo inactivo como predeterminado'
        });
      }

      // Lógica de negocio: crear o actualizar (upsert)
      const existing = await UserPreference.findByUserId(usuario_id);
      
      let result;
      if (existing) {
        // Actualizar preferencias existentes
        result = await UserPreference.updateDefaultModel(usuario_id, modelo_ia_default_id);
        if (!result) {
          throw new Error('No se pudo actualizar las preferencias');
        }
      } else {
        // Crear nuevas preferencias
        result = await UserPreference.create(usuario_id, modelo_ia_default_id);
      }

      res.json({
        message: 'Preferencias actualizadas exitosamente',
        preferences: {
          usuario_id,
          modelo_ia_default_id,
          modelo_nombre: model.nombre,
          proveedor: model.proveedor
        }
      });

    } catch (error) {
      console.error('Error actualizando preferencias:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron actualizar las preferencias'
      });
    }
  }

  // Obtener modelo por defecto del usuario con fallback
  static async getUserDefaultModel(req, res) {
    try {
      const usuario_id = req.user.userId;

      const defaultModel = await UserPreference.getUserDefaultModel(usuario_id);
      
      if (!defaultModel) {
        return res.status(404).json({
          error: 'No hay modelos disponibles',
          message: 'No se encontró un modelo por defecto disponible'
        });
      }

      res.json({
        message: 'Modelo por defecto obtenido exitosamente',
        model: {
          modelo_ia_id: defaultModel.modelo_ia_id,
          proveedor: defaultModel.proveedor,
          nombre: defaultModel.nombre,
          identificador_interno_modelo: defaultModel.identificador_interno_modelo,
          activo: defaultModel.activo === 1,
          is_user_default: true
        }
      });

    } catch (error) {
      console.error('Error obteniendo modelo por defecto del usuario:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo obtener el modelo por defecto'
      });
    }
  }

  // Restablecer preferencias a valores por defecto
  static async resetUserPreferences(req, res) {
    try {
      const usuario_id = req.user.userId;

      // Obtener el modelo por defecto del sistema
      const defaultModel = await AIModel.getDefault();
      if (!defaultModel) {
        return res.status(500).json({
          error: 'Configuración inválida',
          message: 'No hay un modelo por defecto configurado en el sistema'
        });
      }

      // Lógica de negocio: crear o actualizar con modelo por defecto
      const existing = await UserPreference.findByUserId(usuario_id);
      
      let result;
      if (existing) {
        result = await UserPreference.updateDefaultModel(usuario_id, defaultModel.modelo_ia_id);
      } else {
        result = await UserPreference.create(usuario_id, defaultModel.modelo_ia_id);
      }

      if (!result) {
        throw new Error('No se pudieron restablecer las preferencias');
      }

      res.json({
        message: 'Preferencias restablecidas exitosamente',
        preferences: {
          usuario_id,
          modelo_ia_default_id: defaultModel.modelo_ia_id,
          modelo_nombre: defaultModel.nombre,
          proveedor: defaultModel.proveedor
        }
      });

    } catch (error) {
      console.error('Error restableciendo preferencias:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron restablecer las preferencias'
      });
    }
  }
}

module.exports = UserPreferenceController;
