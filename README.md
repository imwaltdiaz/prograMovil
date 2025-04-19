# Desarrollo de una Aplicación Móvil de Chatbot con AI


## 1. Breve explicación del entorno de desarrollo

El entorno de desarrollo para este proyecto constará de:

- **Frontend**: Desarrollado en Flutter, un framework de UI de Google que permite crear aplicaciones nativas multiplataforma (iOS y Android) con un único código base utilizando el lenguaje Dart.
- **Backend**: Implementado en Python, aprovechando bibliotecas como FastAPI o Flask para crear APIs RESTful que conectarán con la API de OpenAI.
- **Base de datos**: SQLite para almacenamiento local de datos de usuario, historial de conversaciones y configuraciones.
- **Integración de IA**: API de OpenAI (ChatGPT) en fase inicial, con arquitectura que facilite el cambio a otros modelos en el futuro.
- **Despliegue**: Servicios de Azure para la infraestructura cloud.

**Herramientas de desarrollo**:
- Flutter SDK y Android Studio/VS Code para desarrollo frontend
- Python con entorno virtual para desarrollo backend
- Git para control de versiones
- Azure DevOps para CI/CD

## 2. Diagrama de despliegue

```mermaid
deployment {
  node "Dispositivo Cliente" {
    [Aplicación Flutter] as App
    database "SQLite Local" as SQLiteLocal
  }

  node "Azure App Service" {
    [Servicio Backend Python] as Backend
    [API Gateway] as Gateway
  }
  
  node "Azure Cognitive Services" {
    [Servicio de Lenguaje] as LangService
  }
  
  cloud "OpenAI" {
    [API ChatGPT] as ChatGPT
  }
  
  node "Azure SQL Database" {
    database "Base de Datos Cloud" as CloudDB
  }
  
  node "Azure Monitor" {
    [Servicio de Monitoreo] as Monitor
  }
  
  App --> SQLiteLocal : "Almacena datos locales"
  App --> Gateway : "Solicitudes HTTPS"
  Gateway --> Backend : "Enruta solicitudes"
  Backend --> CloudDB : "Persiste datos"
  Backend --> LangService : "Procesamiento de lenguaje"
  Backend --> ChatGPT : "Solicitudes a API"
  Monitor --> App : "Monitoreo de cliente"
  Monitor --> Backend : "Monitoreo de servidor"
}

```

## 3. Requerimientos no funcionales

1. **Rendimiento**:
   - Tiempo de respuesta máximo de 3 segundos para solicitudes al chatbot.
   - Capacidad para manejar al menos 100 usuarios concurrentes en fase de prototipo.

2. **Usabilidad**:
   - Interfaz intuitiva que no requiera tutorial para su uso básico.
   - Adaptabilidad a diferentes tamaños de pantalla (diseño responsive).
   - Soporte para modo oscuro y claro.

3. **Seguridad**:
   - Cifrado de datos en tránsito mediante HTTPS.
   - Almacenamiento seguro de credenciales de API.
   - Autenticación de usuarios mediante email/contraseña o proveedores OAuth.

4. **Disponibilidad**:
   - Disponibilidad del 99% durante fase de prototipo.
   - Mecanismo de caché para funcionar con conectividad limitada.

5. **Mantenibilidad**:
   - Código modular y documentado siguiendo estándares de Flutter y Python.
   - Pruebas unitarias con cobertura mínima del 70%.

6. **Escalabilidad**:
   - Arquitectura que permita cambiar entre diferentes proveedores de API de IA.
   - Capacidad para escalar horizontalmente en la nube.

7. **Compatibilidad**:
   - Soporte para Android 8.0+ e iOS 13.0+.
   - Funcionalidad offline básica cuando no haya conexión.

## 4. Diagrama de casos de uso

```mermaid
@startuml
left to right direction
skinparam packageStyle rectangle

actor Usuario
actor "Sistema de IA" as IA
actor Administrador

rectangle "Aplicación de Chatbot" {
  usecase "Registrarse" as UC1
  usecase "Iniciar sesión" as UC2
  usecase "Chatear con IA" as UC3
  usecase "Ver historial de conversaciones" as UC4
  usecase "Personalizar preferencias" as UC5
  usecase "Compartir conversación" as UC6
  usecase "Evaluar respuestas" as UC7
  usecase "Monitorear uso" as UC8
  usecase "Gestionar usuarios" as UC9
  usecase "Cambiar modelo de IA" as UC10
}

Usuario --> UC1
Usuario --> UC2
Usuario --> UC3
Usuario --> UC4
Usuario --> UC5
Usuario --> UC6
Usuario --> UC7

UC3 --> IA

Administrador --> UC8
Administrador --> UC9
Administrador --> UC10
@enduml

```

## 5. Descripción de casos de uso (con mockups)



# Descripción de casos de uso

## CU1: Registrarse
**Actor principal**: Usuario  
**Descripción**: El usuario se registra en la aplicación proporcionando información básica.  
**Flujo principal**:
1. El usuario abre la aplicación por primera vez o selecciona "Registrarse"
2. El sistema muestra opciones de registro (email/contraseña, Google, Apple)
3. El usuario selecciona un método e ingresa la información requerida
4. El sistema valida la información y crea una cuenta
5. El sistema redirige al usuario a la pantalla principal

**Mockup**:
```
┌───────────────────────┐
│     BIENVENIDO A      │
│      AI CHATBOT       │
│                       │
│  ┌─────────────────┐  │
│  │  Email          │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │  Contraseña     │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │    REGISTRAR    │  │
│  └─────────────────┘  │
│                       │
│  ── O continúa con ── │
│                       │
│  ┌───────┐ ┌───────┐  │
│  │Google │ │ Apple │  │
│  └───────┘ └───────┘  │
│                       │
│ ¿Ya tienes cuenta?    │
│     Inicia sesión     │
└───────────────────────┘
```

## CU2: Iniciar sesión
**Actor principal**: Usuario  
**Descripción**: El usuario accede a su cuenta existente.  
**Flujo principal**:
1. El usuario selecciona "Iniciar sesión"
2. El sistema muestra opciones de inicio de sesión
3. El usuario ingresa sus credenciales
4. El sistema valida las credenciales
5. El sistema carga los datos del usuario y muestra la pantalla principal

**Mockup**:
```
┌───────────────────────┐
│     AI CHATBOT        │
│                       │
│  ┌─────────────────┐  │
│  │  Email          │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │  Contraseña     │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │  INICIAR SESIÓN │  │
│  └─────────────────┘  │
│                       │
│  ── O continúa con ── │
│                       │
│  ┌───────┐ ┌───────┐  │
│  │Google │ │ Apple │  │
│  └───────┘ └───────┘  │
│                       │
│ ¿No tienes cuenta?    │
│     Regístrate        │
└───────────────────────┘
```

## CU3: Chatear con IA
**Actor principal**: Usuario  
**Actores secundarios**: Sistema de IA (ChatGPT)  
**Descripción**: El usuario mantiene una conversación con el chatbot de IA.  
**Flujo principal**:
1. El usuario ingresa a la pantalla principal de chat
2. El usuario escribe y envía un mensaje
3. El sistema procesa el mensaje y lo envía a la API de OpenAI
4. La API de OpenAI genera una respuesta
5. El sistema muestra la respuesta en la interfaz de chat
6. El usuario puede continuar la conversación enviando más mensajes

**Flujo alternativo**:
- Si hay un error de conexión, se muestra un mensaje de error
- Si no hay conexión a internet, se utiliza la caché local para funcionalidades básicas

**Mockup**:
```
┌───────────────────────┐
│ ←  Nueva conversación │
├───────────────────────┤
│                       │
│  ┌─────────────────┐  │
│  │ Hola, ¿en qué   │  │
│  │ puedo ayudarte  │  │
│  │ hoy?            │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │ Necesito ayuda  │  │
│  │ con mi tarea de │  │
│  │ matemáticas     │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │ Por supuesto,   │  │
│  │ cuéntame qué    │  │
│  │ problema tienes │  │
│  └─────────────────┘  │
│                       │
├───────────────────────┤
│ ┌─────────────────┐ ▶ │
│ │Escribe mensaje  │   │
└───────────────────────┘
```

## CU4: Ver historial de conversaciones
**Actor principal**: Usuario  
**Descripción**: El usuario accede a sus conversaciones anteriores con el chatbot.  
**Flujo principal**:
1. El usuario selecciona "Historial" o "Conversaciones"
2. El sistema carga las conversaciones previas desde la base de datos local
3. El usuario puede seleccionar una conversación para continuarla
4. El sistema carga el contenido completo de la conversación seleccionada

**Mockup**:
```
┌───────────────────────┐
│     Conversaciones    │
├───────────────────────┤
│  ┌─────────────────┐  │
│  │ Ayuda con mate  │  │
│  │ Hace 2 días     │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │ Plan de viaje   │  │
│  │ 14/04/2025      │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │ Receta de pizza │  │
│  │ 10/04/2025      │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │ Problema física │  │
│  │ 05/04/2025      │  │
│  └─────────────────┘  │
│                       │
├───────────────────────┤
│ 🏠  💬  ⚙️            │
└───────────────────────┘
```

## CU5: Personalizar preferencias
**Actor principal**: Usuario  
**Descripción**: El usuario configura las preferencias de la aplicación y del chatbot.  
**Flujo principal**:
1. El usuario selecciona "Configuración" o "Preferencias"
2. El sistema muestra opciones configurables
3. El usuario modifica preferencias (tema, notificaciones, comportamiento del chatbot)
4. El sistema guarda las preferencias en la base de datos local

**Mockup**:
```
┌───────────────────────┐
│     Configuración     │
├───────────────────────┤
│                       │
│  Perfil               │
│  ► Editar información │
│                       │
│  Apariencia           │
│  ○ Tema claro         │
│  ● Tema oscuro        │
│                       │
│  Chatbot              │
│  ► Estilo de respuesta│
│  ► Longitud preferida │
│                       │
│  Notificaciones       │
│  ■ Mensajes nuevos    │
│  □ Actualizaciones    │
│                       │
│  Privacidad           │
│  ► Historial y datos  │
│                       │
├───────────────────────┤
│ 🏠  💬  ⚙️            │
└───────────────────────┘
```

## CU6: Compartir conversación
**Actor principal**: Usuario  
**Descripción**: El usuario comparte fragmentos o conversaciones completas con otros.  
**Flujo principal**:
1. El usuario selecciona la opción "Compartir" en una conversación
2. El sistema muestra opciones de compartir (texto, imagen, enlace)
3. El usuario selecciona el método y el destinatario
4. El sistema genera el contenido en el formato elegido
5. El contenido se envía usando la aplicación seleccionada por el usuario

**Mockup**:
```
┌───────────────────────┐
│   Compartir chat      │
├───────────────────────┤
│                       │
│  Seleccionar formato: │
│                       │
│  ○ Texto plano        │
│  ● Imagen             │
│  ○ Enlace (próx.)     │
│                       │
│  Incluir:             │
│  ■ Preguntas          │
│  ■ Respuestas         │
│                       │
│  ┌─────────────────┐  │
│  │ Vista previa    │  │
│  │                 │  │
│  │   [Imagen de    │  │
│  │   conversación] │  │
│  │                 │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │    COMPARTIR    │  │
│  └─────────────────┘  │
└───────────────────────┘
```

## CU7: Evaluar respuestas
**Actor principal**: Usuario  
**Descripción**: El usuario proporciona feedback sobre las respuestas del chatbot.  
**Flujo principal**:
1. El sistema muestra opciones de evaluación junto a cada respuesta del chatbot
2. El usuario selecciona una evaluación (pulgar arriba/abajo, estrellas)
3. El sistema registra la evaluación y la envía al backend
4. Opcionalmente, se solicita más detalles sobre la evaluación

**Mockup**:
```
┌───────────────────────┐
│                       │
│  ┌─────────────────┐  │
│  │ La respuesta    │  │
│  │ del chatbot...  │  │
│  │                 │  │
│  │ 👍    👎        │  │
│  └─────────────────┘  │
│                       │
│  ¿Por qué no fue útil?│
│                       │
│  ○ Incorrecta         │
│  ○ Incompleta         │
│  ● No entendió        │
│  ○ Otra razón         │
│                       │
│  ┌─────────────────┐  │
│  │ Comentario...   │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │     ENVIAR      │  │
│  └─────────────────┘  │
└───────────────────────┘
```

## CU8: Monitorear uso
**Actor principal**: Administrador  
**Descripción**: El administrador monitorea el uso de la aplicación y del servicio de API.  
**Flujo principal**:
1. El administrador accede al panel de administración
2. El sistema muestra estadísticas de uso (usuarios activos, consultas por día, evaluaciones)
3. El administrador puede filtrar datos por fecha, tipo de usuario, etc.
4. El sistema muestra gráficos y tablas con la información solicitada

**Mockup**:
```
┌───────────────────────┐
│   Panel de Control    │
├───────────────────────┤
│                       │
│  Estadísticas         │
│  ┌─────────────────┐  │
│  │ Usuarios: 243   │  │
│  │ Activos hoy: 82 │  │
│  └─────────────────┘  │
│                       │
│  ┌─────────────────┐  │
│  │   [Gráfico de   │  │
│  │    actividad]   │  │
│  └─────────────────┘  │
│                       │
│  Uso de API           │
│  ┌─────────────────┐  │
│  │ Total: 1,245    │  │
│  │ Hoy: 143        │  │
│  │ Costo: $12.43   │  │
│  └─────────────────┘  │
│                       │
│  ► Ver detalles       │
│  ► Exportar datos     │
└───────────────────────┘
```

## CU9: Gestionar usuarios
**Actor principal**: Administrador  
**Descripción**: El administrador gestiona las cuentas de usuario y permisos.  
**Flujo principal**:
1. El administrador accede a "Gestión de usuarios"
2. El sistema muestra la lista de usuarios registrados
3. El administrador puede buscar, filtrar, editar o eliminar usuarios
4. El sistema actualiza la base de datos con los cambios realizados

**Mockup**:
```
┌───────────────────────┐
│   Gestión de Usuarios │
├───────────────────────┤
│ ┌───────────────┐ 🔍  │
│ │Buscar usuario  │    │
│ └───────────────┘     │
│                       │
│  Usuario  | Estado    │
│  ─────────┼──────────│
│  Ana M.   | Activo    │
│  Carlos R.| Activo    │
│  Elena T. | Inactivo  │
│  Gabriel P| Activo    │
│           |           │
│  ► Detalles de usuario│
│  ► Exportar lista     │
│  ► Enviar notificación│
│                       │
│  ┌─────────────────┐  │
│  │ + Nuevo usuario │  │
│  └─────────────────┘  │
└───────────────────────┘
```

## CU10: Cambiar modelo de IA
**Actor principal**: Administrador  
**Descripción**: El administrador configura o cambia el proveedor del modelo de IA.  
**Flujo principal**:
1. El administrador accede a "Configuración de IA"
2. El sistema muestra las opciones de proveedores disponibles
3. El administrador selecciona un proveedor y configura parámetros (API keys, modelos)
4. El sistema valida la configuración y actualiza el servicio backend

**Mockup**:
```
┌───────────────────────┐
│  Configuración de IA  │
├───────────────────────┤
│                       │
│  Proveedor actual:    │
│  ● OpenAI             │
│  ○ Azure OpenAI       │
│  ○ Anthropic          │
│  ○ Google Gemini      │
│                       │
│  Modelo:              │
│  ▼ gpt-4o             │
│    gpt-4-turbo        │
│    gpt-3.5-turbo      │
│                       │
│  ┌─────────────────┐  │
│  │ API Key: ●●●●●● │  │
│  └─────────────────┘  │
│                       │
│  Parámetros:          │
│  Temperatura: 0.7     │
│  Max tokens: 4096     │
│                       │
│  ┌─────────────────┐  │
│  │     GUARDAR     │  │
│  └─────────────────┘  │
└───────────────────────┘
```


