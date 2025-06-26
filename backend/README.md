# AI Chatbot Backend

Backend API para la aplicación de chatbot con IA desarrollada en Node.js y Express.

## 📋 Características

- **Autenticación JWT**: Sistema completo de registro y login
- **Base de datos SQLite**: Almacenamiento local con SQLite3
- **Seguridad**: Helmet, CORS, bcrypt para hash de contraseñas
- **Logging**: Morgan para logs de requests
- **Middleware**: Autenticación y manejo de errores
- **Estructura modular**: Controllers, Models, Routes, Services

## 🚀 Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <tu-repositorio>
   cd backend
   ```

2. **Instalar dependencias**
   ```bash
   npm install
   ```

3. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

4. **Iniciar en modo desarrollo**
   ```bash
   npm run dev
   ```

## 📁 Estructura del proyecto

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # Configuración de SQLite
│   ├── controllers/
│   │   └── AuthController.js    # Controlador de autenticación
│   ├── middleware/
│   │   └── auth.js              # Middleware de autenticación JWT
│   ├── models/
│   │   └── User.js              # Modelo de usuario
│   ├── routes/
│   │   ├── auth.js              # Rutas de autenticación
│   │   ├── users.js             # Rutas de usuarios
│   │   └── chat.js              # Rutas del chatbot
│   └── services/                # Servicios (futuro)
├── data_base/
│   └── db.db                    # Base de datos SQLite
├── .env                         # Variables de entorno
├── .gitignore                   # Archivos ignorados por Git
├── index.js                     # Archivo principal del servidor
├── package.json                 # Dependencias y scripts
└── README.md                    # Documentación
```

## 🔧 Scripts disponibles

- `npm start`: Iniciar servidor en producción
- `npm run dev`: Iniciar servidor en desarrollo con nodemon
- `npm test`: Ejecutar tests (pendiente de implementar)

## 🌐 Endpoints de la API

### Autenticación
- `POST /api/auth/register` - Registrar nuevo usuario
- `POST /api/auth/login` - Iniciar sesión
- `GET /api/auth/verify` - Verificar token JWT

### Usuarios
- `GET /api/users/profile` - Obtener perfil del usuario autenticado

### Chat
- `POST /api/chat/message` - Enviar mensaje al chatbot
- `GET /api/chat/history` - Obtener historial de conversaciones

## 🔐 Autenticación

La API utiliza JWT (JSON Web Tokens) para la autenticación. Para acceder a endpoints protegidos, incluye el token en el header:

```
Authorization: Bearer <tu-jwt-token>
```

## 🗃️ Base de datos

### Tablas principales:

**users**
- id (INTEGER, PRIMARY KEY)
- name (TEXT)
- email (TEXT, UNIQUE)
- password (TEXT, hasheado)
- created_at (DATETIME)
- updated_at (DATETIME)

**conversations**
- id (INTEGER, PRIMARY KEY)
- user_id (INTEGER, FK)
- title (TEXT)
- created_at (DATETIME)
- updated_at (DATETIME)

**messages**
- id (INTEGER, PRIMARY KEY)
- conversation_id (INTEGER, FK)
- role (TEXT: 'user' | 'assistant')
- content (TEXT)
- created_at (DATETIME)

## 🔧 Variables de entorno

```env
PORT=3000
NODE_ENV=development
DB_PATH=./data_base/db.db
JWT_SECRET=tu_clave_secreta_super_segura_aqui
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
API_VERSION=v1
```

## 📦 Dependencias principales

- **express**: Framework web
- **sqlite3**: Base de datos
- **bcryptjs**: Hash de contraseñas
- **jsonwebtoken**: Autenticación JWT
- **cors**: Cross-Origin Resource Sharing
- **helmet**: Seguridad HTTP headers
- **morgan**: Logging de requests
- **dotenv**: Variables de entorno

## 🚧 Próximas funcionalidades

- [ ] Integración con API de ChatGPT/Claude
- [ ] Websockets para chat en tiempo real
- [ ] Almacenamiento de conversaciones
- [ ] Sistema de roles de usuario
- [ ] Rate limiting
- [ ] Tests unitarios e integración
- [ ] Documentación con Swagger

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request
