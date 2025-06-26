# Pruebas del Backend - AI Chatbot

Este archivo contiene ejemplos de cómo probar tu backend localmente.

## 🚀 Despliegue Local

### 1. Instalar dependencias (solo la primera vez)
```bash
cd "c:\Users\Sebastian\Desktop\progra movil\prograMovil\backend"
npm install
```

### 2. Iniciar el servidor

**Modo desarrollo (recomendado):**
```bash
npm run dev
```
- Reinicia automáticamente cuando cambias código
- Puerto: 3001
- URL: http://localhost:3001

**Modo producción:**
```bash
npm start
```

### 3. Verificar que funciona
Abre tu navegador en: http://localhost:3001
Deberías ver un JSON con información del API.

---

## 🧪 Cómo Testear el Backend

### Opción 1: Usar VS Code con la extensión REST Client

1. Instala la extensión "REST Client" en VS Code
2. Crea un archivo `.http` con las siguientes pruebas:

```http
### 1. Verificar que el servidor funciona
GET http://localhost:3001

### 2. Registrar un nuevo usuario
POST http://localhost:3001/api/auth/register
Content-Type: application/json

{
  "name": "Sebastian Test",
  "email": "sebastian@test.com",
  "password": "123456"
}

### 3. Iniciar sesión
POST http://localhost:3001/api/auth/login
Content-Type: application/json

{
  "email": "sebastian@test.com",
  "password": "123456"
}

### 4. Verificar token (usa el token del login anterior)
GET http://localhost:3001/api/auth/verify
Authorization: Bearer TU_TOKEN_AQUI

### 5. Obtener perfil de usuario
GET http://localhost:3001/api/users/profile
Authorization: Bearer TU_TOKEN_AQUI

### 6. Enviar mensaje al chatbot
POST http://localhost:3001/api/chat/message
Content-Type: application/json
Authorization: Bearer TU_TOKEN_AQUI

{
  "message": "Hola, ¿cómo estás?"
}

### 7. Obtener historial de chat
GET http://localhost:3001/api/chat/history
Authorization: Bearer TU_TOKEN_AQUI
```

### Opción 2: Usar PowerShell/CMD

**1. Probar servidor:**
```powershell
curl http://localhost:3001
```

**2. Registrar usuario:**
```powershell
curl -X POST http://localhost:3001/api/auth/register -H "Content-Type: application/json" -d '{\"name\":\"Sebastian Test\",\"email\":\"sebastian@test.com\",\"password\":\"123456\"}'
```

**3. Iniciar sesión:**
```powershell
curl -X POST http://localhost:3001/api/auth/login -H "Content-Type: application/json" -d '{\"email\":\"sebastian@test.com\",\"password\":\"123456\"}'
```

### Opción 3: Usar Postman

1. Descarga Postman: https://www.postman.com/downloads/
2. Crea una nueva colección llamada "AI Chatbot Backend"
3. Añade las siguientes requests:

**GET** `http://localhost:3001` (Verificar servidor)

**POST** `http://localhost:3001/api/auth/register` (Registro)
```json
{
  "name": "Sebastian Test",
  "email": "sebastian@test.com", 
  "password": "123456"
}
```

**POST** `http://localhost:3001/api/auth/login` (Login)
```json
{
  "email": "sebastian@test.com",
  "password": "123456"
}
```

---

## 📱 Configuración para Flutter

Cuando conectes desde tu app Flutter, usa esta URL base:
```dart
const String API_BASE_URL = 'http://localhost:3001/api';

// Para dispositivos físicos Android, usa la IP de tu PC:
// const String API_BASE_URL = 'http://192.168.1.XXX:3001/api';
```

---

## 🔧 Solución de Problemas

### Puerto ocupado:
```bash
# Ver qué proceso usa el puerto 3001
netstat -ano | findstr :3001

# Matar proceso (cambia PID por el número que aparece)
taskkill /PID [NUMERO_PID] /F
```

### Reinstalar dependencias:
```bash
rm -rf node_modules package-lock.json
npm install
```

### Ver logs en tiempo real:
El servidor con `npm run dev` muestra logs automáticamente.

---

## 📊 Estados de Respuesta

- **200**: Éxito
- **201**: Creado (registro exitoso)
- **400**: Datos incorrectos
- **401**: No autenticado
- **403**: Token inválido
- **404**: Endpoint no encontrado
- **409**: Usuario ya existe
- **500**: Error del servidor
