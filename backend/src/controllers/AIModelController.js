const AIModel = require('../models/AIModel');

class AIModelController {
  // ============================================
  // LÓGICA DE NEGOCIO - OBTENER MODELOS
  // ============================================
  
  // Obtener todos los modelos activos
  static async getActiveModels(req, res) {
    try {
      const models = await AIModel.findActive();
      
      // Formatear datos para respuesta
      const formattedModels = models.map(model => model.getPublicData());

      res.json({
        message: 'Modelos activos obtenidos exitosamente',
        models: formattedModels
      });

    } catch (error) {
      console.error('Error obteniendo modelos activos:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener los modelos'
      });
    }
  }

  // Obtener todos los modelos (para admin)
  static async getAllModels(req, res) {
    try {
      const models = await AIModel.findAll();
      
      // Formatear datos para respuesta
      const formattedModels = models.map(model => model.getPublicData());

      res.json({
        message: 'Todos los modelos obtenidos exitosamente',
        models: formattedModels
      });

    } catch (error) {
      console.error('Error obteniendo todos los modelos:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener los modelos'
      });
    }
  }

  // Obtener modelo por ID
  static async getModelById(req, res) {
    try {
      const { id } = req.params;

      // Validación de entrada
      if (!id || isNaN(id)) {
        return res.status(400).json({
          error: 'ID inválido',
          message: 'Se requiere un ID de modelo válido'
        });
      }

      const model = await AIModel.findById(parseInt(id));
      
      if (!model) {
        return res.status(404).json({
          error: 'Modelo no encontrado',
          message: 'No existe un modelo con el ID proporcionado'
        });
      }

      res.json({
        message: 'Modelo obtenido exitosamente',
        model: model.getPublicData()
      });

    } catch (error) {
      console.error('Error obteniendo modelo por ID:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo obtener el modelo'
      });
    }
  }

  // Obtener modelos por proveedor
  static async getModelsByProvider(req, res) {
    try {
      const { provider } = req.params;

      // Validación de entrada
      if (!provider) {
        return res.status(400).json({
          error: 'Proveedor requerido',
          message: 'Se requiere especificar un proveedor'
        });
      }

      const models = await AIModel.findByProvider(provider);
      
      // Formatear datos para respuesta
      const formattedModels = models.map(model => model.getPublicData());

      res.json({
        message: `Modelos de ${provider} obtenidos exitosamente`,
        provider,
        models: formattedModels
      });

    } catch (error) {
      console.error('Error obteniendo modelos por proveedor:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudieron obtener los modelos del proveedor'
      });
    }
  }

  // Obtener modelo por defecto
  static async getDefaultModel(req, res) {
    try {
      const model = await AIModel.getDefault();
      
      if (!model) {
        return res.status(404).json({
          error: 'No hay modelos disponibles',
          message: 'No existe un modelo por defecto configurado'
        });
      }

      res.json({
        message: 'Modelo por defecto obtenido exitosamente',
        model: model.getPublicData()
      });

    } catch (error) {
      console.error('Error obteniendo modelo por defecto:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo obtener el modelo por defecto'
      });
    }
  }

  // Verificar si un modelo está activo (lógica de negocio)
  static async checkModelStatus(req, res) {
    try {
      const { id } = req.params;

      // Validación de entrada
      if (!id || isNaN(id)) {
        return res.status(400).json({
          error: 'ID inválido',
          message: 'Se requiere un ID de modelo válido'
        });
      }

      const model = await AIModel.findById(parseInt(id));
      
      if (!model) {
        return res.status(404).json({
          error: 'Modelo no encontrado',
          message: 'No existe un modelo con el ID proporcionado'
        });
      }

      // Lógica de negocio: verificar si está activo
      const isActive = model.activo === 1;

      res.json({
        message: 'Estado del modelo verificado',
        model_id: model.modelo_ia_id,
        name: model.nombre,
        provider: model.proveedor,
        is_active: isActive,
        status: isActive ? 'Activo' : 'Inactivo'
      });

    } catch (error) {
      console.error('Error verificando estado del modelo:', error);
      res.status(500).json({
        error: 'Error interno del servidor',
        message: 'No se pudo verificar el estado del modelo'
      });
    }
  }
}

module.exports = AIModelController;
