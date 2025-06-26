# Arquitectura Refactorizada - Separación de Responsabilidades

## Resumen de Cambios

Se ha refactorizado completamente el backend para seguir correctamente el patrón **MVC (Model-View-Controller)** con una separación clara de responsabilidades:

## Estructura Actual

### 📁 **Modelos (src/models/)**
Los modelos ahora son **únicamente para acceso a datos** (CRUD):

- **User.js** - Solo métodos de base de datos (create, findByEmail, findById, updateLastAccess, etc.)
- **Conversation.js** - Solo operaciones CRUD de conversaciones
- **Message.js** - Solo operaciones CRUD de mensajes  
- **AIModel.js** - Solo operaciones CRUD de modelos de IA
- **UserPreference.js** - Solo operaciones CRUD de preferencias

#### ❌ **Removido de Modelos:**
- Validación de contraseñas (ahora en controladores)
- Formateo de datos de respuesta (ahora en controladores)  
- Lógica de negocio compleja (ahora en controladores)
- Métodos helper como `isActive()`, `toJSON()` (ahora en controladores)

### 🎮 **Controladores (src/controllers/)**
Los controladores ahora manejan **toda la lógica de negocio**:

#### **AuthController.js**
- Validaciones de entrada
- Hash de contraseñas con bcrypt
- Verificación de contraseñas
- Generación y validación de JWT
- Coordinación entre modelos

#### **ConversationController.js** 
- Validaciones de permisos de usuario
- Lógica para seleccionar modelos por defecto
- Coordinación entre conversaciones y mensajes
- Formateo de respuestas

#### **AIModelController.js** ✨ **NUEVO**
- Validaciones de entrada
- Verificación de estado de modelos
- Formateo de datos públicos
- Lógica para modelos por defecto

#### **UserPreferenceController.js** ✨ **NUEVO**
- Lógica de upsert (crear o actualizar)
- Validaciones de modelos activos
- Fallbacks a modelos por defecto
- Coordinación entre preferencias y modelos

#### **MessageController.js** ✨ **NUEVO**
- Validaciones de permisos y entrada
- Lógica de paginación y límites
- Coordinación entre mensajes y conversaciones
- Estadísticas y conteos

### 🛣️ **Rutas Refactorizadas (src/routes/)**
Las rutas ahora solo delegan a controladores:

```javascript
// Antes (lógica mezclada en rutas):
router.get('/', async (req, res) => {
  try {
    // 20+ líneas de lógica aquí
  } catch (error) {
    // manejo de errores
  }
});

// Ahora (delegación limpia):
router.get('/', AIModelController.getActiveModels);
```

## Beneficios de la Refactorización

### ✅ **Separación de Responsabilidades**
- **Modelos**: Solo acceso a datos (CRUD)
- **Controladores**: Solo lógica de negocio y validaciones
- **Rutas**: Solo routing y middleware

### ✅ **Mantenibilidad**
- Código más organizado y fácil de entender
- Cambios aislados por responsabilidad
- Fácil agregar nuevas funcionalidades

### ✅ **Testabilidad**
- Cada capa se puede testear independientemente
- Mocks más simples para unit tests
- Lógica de negocio aislada

### ✅ **Escalabilidad**
- Fácil agregar nuevos controladores
- Reutilización de modelos entre controladores
- Consistencia en validaciones y formateo

## Principales Cambios por Archivo

### User.js
```javascript
// ❌ REMOVIDO:
async verifyPassword(password) {
  return await bcrypt.compare(password, this.password_hash);
}

toJSON() {
  return { /* formateo */ };
}

// ✅ AHORA:
getPublicData() {
  return { /* solo datos sin lógica */ };
}
```

### AuthController.js
```javascript
// ✅ AGREGADO:
const isValidPassword = await bcrypt.compare(password, user.password_hash);
// Toda la lógica de validación de contraseñas ahora aquí
```

### Nuevos Controladores
- **AIModelController**: 6 endpoints con lógica de negocio
- **UserPreferenceController**: 4 endpoints con upsert logic
- **MessageController**: 5 endpoints con validaciones complejas

## Flujo de Datos Refactorizado

```
Request → Route → Controller → Model → Database
                     ↑              ↓
             [Lógica de Negocio]  [Solo CRUD]
                     ↓
Response ← Formato ← Validación
```

### Antes (❌ Arquitectura Mezclada):
```
Request → Route/Model (mezclado) → Database
                ↓
Response ← Lógica mezclada
```

### Ahora (✅ Arquitectura Limpia):
```
Request → Route → Controller → Model → Database
Response ← Controller ← Model ← Database
```

## Endpoints Actualizados

Todos los endpoints ahora usan controladores especializados:

- `/api/ai-models/*` → **AIModelController**
- `/api/preferences/*` → **UserPreferenceController**  
- `/api/messages/*` → **MessageController**
- `/api/conversations/*` → **ConversationController**
- `/api/auth/*` → **AuthController**

## Próximos Pasos

1. **Testing**: Crear tests unitarios para cada controlador
2. **Documentación**: Actualizar documentación de API
3. **Optimización**: Revisar queries de base de datos
4. **Integración**: Conectar con frontend/móvil
5. **IA**: Integrar servicios reales de IA

## Validación

✅ Servidor arranca correctamente en puerto 3001  
✅ Endpoints responden con nueva arquitectura  
✅ Modelos solo contienen acceso a datos  
✅ Controladores manejan toda la lógica de negocio  
✅ Rutas son simples y limpias  

La refactorización está **completa y funcional**. El backend ahora sigue correctamente el patrón MVC con separación clara de responsabilidades.
