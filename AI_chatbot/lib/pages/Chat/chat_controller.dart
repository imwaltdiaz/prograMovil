// lib/pages/chat/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/mensaje.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import '../../services/mensaje_service.dart';
import '../../services/conversacion_service.dart';
import '../../services/gemini_ai_service.dart';

class ChatController extends GetxController {
  final MensajeService _mensajeService = MensajeService();
  final ConversacionService _conversacionService = ConversacionService();
  final GeminiAIService _geminiAIService = GeminiAIService();

  late final Usuario user;
  Conversacion? conversacion; // Permitir que sea null
  var mensajes = <Mensaje>[].obs;
  final TextEditingController messageTextController = TextEditingController();

  // Estados para la IA
  var isAIResponding = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      user = args['user'] as Usuario;
      final conversacionId = args['conversacionId'] as int?;

      if (conversacionId != null) {
        print(
            '>> [ChatController] Cargando conversación existente: $conversacionId');
        _cargarConversacionExistente(conversacionId);
      } else {
        print('>> [ChatController] Creando nueva conversación...');
        _crearNuevaConversacion();
      }
    } else if (args is Usuario) {
      // Compatibilidad con el formato anterior
      user = args;
      print(
          '>> [ChatController] Usuario recibido, creando nueva conversación...');
      _crearNuevaConversacion();
    } else {
      print(
          '>> [ChatController] No recibí argumentos válidos. Volviendo atrás.');
      Get.back();
    }
  }

  /// Cargar una conversación existente con sus mensajes
  Future<void> _cargarConversacionExistente(int conversacionId) async {
    try {
      // Primero obtenemos la conversación
      final conversaciones = await _conversacionService
          .getConversacionesPorUsuario(user.usuario_id);
      conversacion = conversaciones
          .firstWhereOrNull((c) => c.conversacion_id == conversacionId);

      if (conversacion != null) {
        // Luego cargamos los mensajes
        await _cargarMensajesDeConversacion(conversacionId);
        print(
            '>> [ChatController] Conversación cargada: ${conversacion!.titulo}');
      } else {
        print(
            '>> [ChatController] Conversación no encontrada, creando nueva...');
        _crearNuevaConversacion();
      }
    } catch (e) {
      print('>> [ChatController] Error cargando conversación: $e');
      _crearNuevaConversacion();
    }
  }

  Future<void> _cargarMensajesDeConversacion(int converId) async {
    final lista = await _mensajeService.getMensajesPorConversacion(converId);
    mensajes.assignAll(lista);
    print(
        '>> [ChatController] Mensajes cargados para conversacion $converId: ${mensajes.length}');
  }

  Future<void> sendMessage() async {
    final texto = messageTextController.text.trim();
    if (texto.isEmpty || conversacion == null) return;

    // Si es el primer mensaje, actualizar el título de la conversación
    final esElPrimerMensaje = mensajes.isEmpty;

    // Crear mensaje del usuario
    final mensajeUsuario = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch,
      conversacion_id: conversacion!.conversacion_id,
      remitente: RemitenteType.usuario,
      contenido_texto: texto,
      timestamp_envio: DateTime.now(),
    );

    // Agregar mensaje del usuario a la UI inmediatamente
    mensajes.add(mensajeUsuario);
    messageTextController.clear();

    // Actualizar título de conversación si es el primer mensaje
    if (esElPrimerMensaje) {
      final nuevoTitulo =
          texto.length > 30 ? '${texto.substring(0, 30)}...' : texto;
      await _actualizarTituloConversacion(nuevoTitulo);
    }

    // Guardar mensaje del usuario en el backend
    final guardadoUsuario =
        await _mensajeService.guardarMensaje(mensajeUsuario);
    if (guardadoUsuario) {
      print('✅ Mensaje de usuario guardado en backend');
    } else {
      print('❌ Error guardando mensaje de usuario en backend');
    }

    // Indicar que la IA está procesando
    isAIResponding.value = true;

    try {
      // Enviar mensaje a Gemini AI
      print('🤖 Enviando mensaje a Gemini AI: $texto');
      final respuestaIA = await _geminiAIService.sendMessage(texto);

      // Crear mensaje de respuesta de la IA
      final mensajeIA = Mensaje(
        mensaje_id: DateTime.now().millisecondsSinceEpoch + 1,
        conversacion_id: conversacion!.conversacion_id,
        remitente: RemitenteType.ia,
        contenido_texto: respuestaIA,
        timestamp_envio: DateTime.now(),
      );

      // Agregar respuesta de la IA a la UI
      mensajes.add(mensajeIA);

      // Guardar mensaje de la IA en el backend
      final guardadoIA = await _mensajeService.guardarMensaje(mensajeIA);
      if (guardadoIA) {
        print('✅ Respuesta de IA guardada en backend');
      } else {
        print('❌ Error guardando respuesta de IA en backend');
      }
    } catch (e) {
      print('❌ Error obteniendo respuesta de Gemini: $e');

      // Mostrar mensaje de error al usuario
      final mensajeError = Mensaje(
        mensaje_id: DateTime.now().millisecondsSinceEpoch + 1,
        conversacion_id: conversacion!.conversacion_id,
        remitente: RemitenteType.ia,
        contenido_texto:
            '❌ Error: ${e.toString()}\n\nPor favor verifica tu configuración de API Key en Configuración > Modelo de IA.',
        timestamp_envio: DateTime.now(),
      );

      mensajes.add(mensajeError);
    } finally {
      // Ocultar indicador de procesamiento
      isAIResponding.value = false;
    }
  }

  /// Actualizar el título de la conversación con el primer mensaje
  Future<void> _actualizarTituloConversacion(String nuevoTitulo) async {
    try {
      if (conversacion != null) {
        // Actualizar localmente
        conversacion!.titulo = nuevoTitulo;

        // Intentar actualizar en el backend (sin bloquear si falla)
        await _conversacionService.actualizarConversacion(
          conversacion!.conversacion_id,
          titulo: nuevoTitulo,
        );
        print('✅ Título de conversación actualizado: $nuevoTitulo');
      }
    } catch (e) {
      print('⚠️ Error actualizando título de conversación: $e');
      // No es crítico si falla
    }
  }

  Future<void> _crearNuevaConversacion() async {
    try {
      print('>> [ChatController] Creando nueva conversación en el backend...');

      final nuevaConversacion = await _conversacionService.crearConversacion(
        usuarioId: user.usuario_id,
        titulo: 'Nueva conversación',
        modeloIaId: 1,
      );

      if (nuevaConversacion != null) {
        conversacion = nuevaConversacion;
        print(
            '>> [ChatController] Nueva conversación creada en backend: ${conversacion!.conversacion_id}');

        // Inicializar lista de mensajes vacía
        mensajes.clear();
      } else {
        print(
            '>> [ChatController] Error creando conversación, usando conversación local temporal');
        // Fallback: crear conversación local temporal
        conversacion = Conversacion(
          conversacion_id: DateTime.now().millisecondsSinceEpoch,
          usuario_id: user.usuario_id,
          titulo: 'Nueva conversación',
          fecha_creacion: DateTime.now(),
          ultima_actualizacion: DateTime.now(),
          modelo_ia_id: 1,
        );
        mensajes.clear();
      }
    } catch (e) {
      print('>> [ChatController] Error creando conversación: $e');
      // Fallback: crear conversación local temporal
      conversacion = Conversacion(
        conversacion_id: DateTime.now().millisecondsSinceEpoch,
        usuario_id: user.usuario_id,
        titulo: 'Nueva conversación',
        fecha_creacion: DateTime.now(),
        ultima_actualizacion: DateTime.now(),
        modelo_ia_id: 1,
      );
      mensajes.clear();
    }
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }
}
