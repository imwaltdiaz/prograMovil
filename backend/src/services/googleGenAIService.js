const { GoogleGenerativeAI } = require('@google/generative-ai');

// Configurar la API key desde variables de entorno
const apiKey = process.env.GOOGLE_AI_API_KEY || 'xddddddd';
const genAI = new GoogleGenerativeAI(apiKey);

class GoogleGenAIService {
  constructor() {
    this.model = genAI.getGenerativeModel({ model: "gemini-2.0-flash-exp" });
  }

  async generateContent(contents, options = {}) {
    try {
      console.log('🚀 Iniciando generateContent...');
      console.log('📝 Contenido recibido:', contents);
      console.log('⚙️ Opciones:', options);

      const {
        temperature = 0.7,
        maxOutputTokens = 4096,
        topP = 0.8,
        topK = 40
      } = options;

      const generationConfig = {
        temperature,
        maxOutputTokens,
        topP,
        topK,
      };

      const safetySettings = [
        {
          category: 'HARM_CATEGORY_HARASSMENT',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          category: 'HARM_CATEGORY_HATE_SPEECH',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE',
        },
      ];

      console.log('🚀 Enviando mensaje a Google GenAI...');
      console.log('📝 Contenido:', contents);

      const result = await this.model.generateContent(contents);

      console.log('📨 Resultado obtenido:', result);
      const response = await result.response;
      console.log('📋 Response obtenida:', response);
      const text = response.text();

      console.log('✅ Respuesta de Google GenAI recibida:', text);
      return text;
    } catch (error) {
      console.error('❌ Error en GoogleGenAIService:', error);
      throw new Error(`Error generando contenido: ${error.message}`);
    }
  }

  async validateApiKey() {
    try {
      const testResult = await this.model.generateContent('Hola');
      return !!testResult.response;
    } catch (error) {
      console.error('Error validando API key:', error);
      return false;
    }
  }

  async getAvailableModels() {
    try {
      // Por ahora retornamos modelos conocidos
      return [
        'gemini-2.0-flash-exp',
        'gemini-pro',
        'gemini-pro-vision'
      ];
    } catch (error) {
      console.error('Error obteniendo modelos:', error);
      return ['gemini-2.0-flash-exp'];
    }
  }
}

// Exportar una instancia singleton
const googleGenAIService = new GoogleGenAIService();

module.exports = {
  generateContent: (contents, options) => googleGenAIService.generateContent(contents, options),
  validateApiKey: () => googleGenAIService.validateApiKey(),
  getAvailableModels: () => googleGenAIService.getAvailableModels(),
};