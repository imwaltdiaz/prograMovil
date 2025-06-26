# Modelos del Backend

Este archivo documenta todos los modelos de datos implementados en el backend del chatbot.

## 📁 Estructura de Modelos

### 1. **User.js** - Usuarios del sistema
```javascript
{
  usuario_id: INTEGER,
  email: STRING,
  password_hash: STRING, 
  nombre: STRING,
  fecha_registro: TIMESTAMP,
  ultimo_acceso: TIMESTAMP,
  imagen_url: STRING
}
```

**Métodos principales:**
- `User.create(userData)` - Crear usuario
- `User.findByEmail(email)` - Buscar por email
- `User.findById(id)` - Buscar por ID
- `user.verifyPassword(password)` - Verificar contraseña
- `user.updateLastAccess()` - Actualizar último acceso

---

### 2. **AIModel.js** - Modelos de IA disponibles
```javascript
{
  modelo_ia_id: INTEGER,
  proveedor: STRING, // 'OpenAI', 'Anthropic', etc.
  nombre: STRING,    // 'GPT-4', 'Claude 3', etc.
  identificador_interno_modelo: STRING, // 'gpt-4', 'claude-3-haiku-20240307'
  activo: BOOLEAN
}
```

**Métodos principales:**
- `AIModel.create(modelData)` - Crear modelo
- `AIModel.findActive()` - Modelos activos
- `AIModel.findById(id)` - Buscar por ID
- `AIModel.findByProvider(provider)` - Por proveedor
- `AIModel.getDefault()` - Modelo por defecto

---

### 3. **Conversation.js** - Conversaciones del chatbot
```javascript
{
  conversacion_id: INTEGER,
  usuario_id: INTEGER,
  modelo_ia_id: INTEGER,
  titulo: STRING,
  fecha_creacion: TIMESTAMP,
  ultima_actualizacion: TIMESTAMP
}
```

**Métodos principales:**
- `Conversation.create(data)` - Crear conversación
- `Conversation.findByUserId(userId)` - Por usuario
- `Conversation.findById(id)` - Por ID
- `Conversation.updateLastActivity(id)` - Actualizar actividad
- `Conversation.delete(id)` - Eliminar

---

### 4. **Message.js** - Mensajes individuales
```javascript
{
  mensaje_id: INTEGER,
  conversacion_id: INTEGER,
  remitente: STRING, // 'user' o 'assistant'
  contenido_texto: STRING,
  timestamp_envio: TIMESTAMP
}
```

**Métodos principales:**
- `Message.create(data)` - Crear mensaje
- `Message.findByConversationId(id)` - Por conversación
- `Message.findById(id)` - Por ID
- `Message.getRecentByUserId(userId)` - Recientes del usuario
- `Message.countByConversationId(id)` - Contar mensajes

---

### 5. **UserPreference.js** - Preferencias del usuario
```javascript
{
  usuario_id: INTEGER,
  modelo_ia_default_id: INTEGER
}
```

**Métodos principales:**
- `UserPreference.create(userId, modelId)` - Crear preferencias
- `UserPreference.findByUserId(userId)` - Por usuario
- `UserPreference.updateDefaultModel(userId, modelId)` - Actualizar modelo
- `UserPreference.upsert(userId, modelId)` - Crear o actualizar
- `UserPreference.getUserDefaultModel(userId)` - Modelo por defecto

---

## 🔗 Relaciones entre Modelos

```
usuarios (1) ──────┐
                   │
                   ├── conversaciones (N)
                   │        │
                   │        └── mensajes (N)
                   │
                   └── preferencias_usuario (1)
                            │
                            └── modelos_ia (1)
```

## 🎯 Casos de Uso Comunes

### Crear nueva conversación:
```javascript
// 1. Obtener modelo por defecto del usuario
const defaultModel = await UserPreference.getUserDefaultModel(userId);

// 2. Crear conversación
const conversation = await Conversation.create({
  usuario_id: userId,
  modelo_ia_id: defaultModel.modelo_ia_id,
  titulo: "Nueva conversación"
});

// 3. Crear primer mensaje
const message = await Message.create({
  conversacion_id: conversation.conversacion_id,
  remitente: 'user',
  contenido_texto: 'Hola!'
});
```

### Obtener historial completo:
```javascript
// 1. Obtener conversaciones del usuario
const conversations = await Conversation.findByUserId(userId);

// 2. Para cada conversación, obtener mensajes
for (const conv of conversations) {
  const messages = await Message.findByConversationId(conv.conversacion_id);
  conv.messages = messages;
}
```

## 📋 Validaciones Implementadas

- **Email único** en usuarios
- **Modelos activos** solamente en conversaciones
- **Remitente válido** ('user' o 'assistant') en mensajes
- **Referencias foráneas** válidas entre tablas

## 🔄 Diferencias con el esquema original

El modelo original (`User.js` simple) ha sido reemplazado para coincidir con tu esquema de base de datos que incluye:

- ✅ Tablas con nombres en español
- ✅ Campos específicos de tu diseño
- ✅ Relaciones entre todas las entidades
- ✅ Modelos de IA configurables
- ✅ Preferencias por usuario
- ✅ Sistema completo de conversaciones

Todos los modelos están listos para usar con tu base de datos existente.
