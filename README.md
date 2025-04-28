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

La arquitectura a usar será una aplicación móvil desarrollada en Flutter y un backend en Python desplegado en Azure. La aplicación móvil utiliza SQLite local para el almacenamiento inmediato de datos de usuario y conversaciones, y accede al backend a través de un API Gateway en Azure App Service mediante solicitudes HTTPS, mientras que el backend persiste la información en Azure SQL Database, enruta las operaciones de lenguaje natural al Servicio de Lenguaje de Azure Cognitive Services o a la API de ChatGPT de OpenAI, y publica métricas y logs en Azure Monitor. Este modelo de la Figura 2 ilustra cómo los clientes interactúan con los distintos componentes y cómo se gestionan los datos y servicios en la nube.

<b>*Figura 1:*</b> Diagrama de Despliegue

![Diagrama de Despliegue](<docs/Diagrama de Despliegue.png>)

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

El siguiente diagrama de casos de uso representa las principales interacciones dentro de la Aplicación de Chatbot, basado en el modelo de requerimientos funcionales definido previamente. En este sistema, los usuarios pueden registrarse, iniciar sesión, chatear con el Sistema de IA, ver su historial de conversaciones, personalizar sus preferencias, compartir diálogos y evaluar la calidad de las respuestas recibidas. Por su parte, el Sistema de IA participa directamente en la generación de respuestas durante el caso de uso “Chatear con IA”, mientras que los administradores disponen de permisos adicionales para monitorear el uso de la plataforma, gestionar usuarios y cambiar el modelo de IA. Estas funcionalidades garantizan una experiencia interactiva, adaptable y fácilmente administrable dentro del prototipo móvil.

<b>*Figura 2:*</b> Diagrama de Casos de Uso

![Diagrama de Casos de Uso](<docs/UC_1.JPEG>)
![Diagrama de Casos de Uso](<docs/UC_2.JPEG>)
![Diagrama de Casos de Uso](<docs/UC_3.JPEG>)

A continuación se detallan los casos de uso:

| ID   | Caso de Uso                         | Descripción                                                                                       |
|------|-------------------------------------|---------------------------------------------------------------------------------------------------|
| UC1  | Registrarse                         | Permite crear una cuenta en la aplicación proporcionando correo electrónico y contraseña.         |
| UC2  | Iniciar sesión                      | Permite autenticarse en la aplicación ingresando las credenciales de usuario registradas.         |
| UC3  | Chatear con IA                      | Permite enviar mensajes al Sistema de IA y recibir respuestas generadas en tiempo real.           |
| UC4  | Ver historial de conversaciones     | Permite consultar y navegar por las conversaciones previas almacenadas en la base de datos local. |
| UC5  | Personalizar preferencias           | Permite ajustar opciones de la aplicación como tema, notificaciones y configuración de modelo IA. |
| UC6  | Compartir conversación              | Permite exportar o enviar el contenido de una conversación a través de correo u otras aplicaciones.|
| UC7  | Evaluar respuestas                  | Permite calificar la calidad o relevancia de las respuestas proporcionadas por la IA.             |
| UC8 | Cambiar modelo de IA                | Permite al usuario seleccionar y configurar el proveedor o versión del modelo de IA.       |

Y el diagrama de clases es el siguiente:
## DIAGRAMA DE CLASES

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
![CU1 Mockup](./img/cu1.png)

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
![CU2 Mockup](./img/cu2.png)

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
![CU3 Mockup](./img/cu3.png)

## CU4: Ver historial de conversaciones
**Actor principal**: Usuario  
**Descripción**: El usuario accede a sus conversaciones anteriores con el chatbot.  
**Flujo principal**:
1. El usuario selecciona "Historial" o "Conversaciones"
2. El sistema carga las conversaciones previas desde la base de datos local
3. El usuario puede seleccionar una conversación para continuarla
4. El sistema carga el contenido completo de la conversación seleccionada

**Mockup**:  
![CU4 Mockup](./img/cu4.png)

## CU5: Personalizar preferencias
**Actor principal**: Usuario  
**Descripción**: El usuario configura las preferencias de la aplicación y del chatbot.  
**Flujo principal**:
1. El usuario selecciona "Configuración" o "Preferencias"
2. El sistema muestra opciones configurables
3. El usuario modifica preferencias (tema, notificaciones, comportamiento del chatbot)
4. El sistema guarda las preferencias en la base de datos local

**Mockup**:  
![CU5 Mockup](./img/cu5.png)

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
![CU6 Mockup](./img/cu6.png)

## CU7: Evaluar respuestas
**Actor principal**: Usuario  
**Descripción**: El usuario proporciona feedback sobre las respuestas del chatbot.  
**Flujo principal**:
1. El sistema muestra opciones de evaluación junto a cada respuesta del chatbot
2. El usuario selecciona una evaluación (pulgar arriba/abajo, estrellas)
3. El sistema registra la evaluación y la envía al backend
4. Opcionalmente, se solicita más detalles sobre la evaluación

**Mockup**:  
![CU7 Mockup](./img/cu7.png)

## CU8: Cambiar modelo de IA
**Actor principal**: usuario  
**Descripción**: El usuario configura o cambia el proveedor del modelo de IA.  
**Flujo principal**:
1. El usuario accede a "Configuración de IA"
2. El sistema muestra las opciones de proveedores disponibles
3. El usuario selecciona un proveedor y configura parámetros (API keys, modelos)
4. El sistema valida la configuración y actualiza el servicio backend

**Mockup**:  
![CU8 Mockup](./img/cu8.png)

## 6. Diagrama de Base de Datos

El siguiente diagrama representa la estructura de la base de datos utilizada en la aplicación. Incluye las tablas principales para almacenar información de usuarios, conversaciones, preferencias y evaluaciones. Este diseño asegura un acceso eficiente y seguro a los datos necesarios para el funcionamiento del sistema.

<b>*Figura 3:*</b> Diagrama de Base de Datos

![Diagrama de Base de Datos](./img/bd_diagrama.png)