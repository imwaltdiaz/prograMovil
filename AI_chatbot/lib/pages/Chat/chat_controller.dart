// lib/pages/chat/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/mensaje.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import '../../services/mensaje_service.dart';
import '../../services/conversacion_service.dart';

class ChatController extends GetxController {
  final MensajeService _mensajeService = MensajeService();
  final ConversacionService _conversacionService = ConversacionService();

  late final Usuario user;
  Conversacion? conversacion; // Permitir que sea null
  var mensajes = <Mensaje>[].obs;
  final TextEditingController messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      user = args['user'] as Usuario;
      conversacion = args['conversacion'] as Conversacion?; // Permitir null

      if (conversacion != null) {
        print(
            '>> [ChatController] Usuario=${user.email}, ConversacionId=${conversacion!.conversacion_id}');
        _cargarMensajesDeConversacion(conversacion!.conversacion_id);
      } else {
        print(
            '>> [ChatController] No hay conversación específica, creando nueva...');
        _crearNuevaConversacion();
      }
    } else {
      print(
          '>> [ChatController] No recibí argumentos válidos. Volviendo atrás.');
      Get.back();
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

    final mensajeUsuario = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch,
      conversacion_id: conversacion!.conversacion_id,
      remitente: RemitenteType.usuario,
      contenido_texto: texto,
      timestamp_envio: DateTime.now(),
    );

    // Agregar mensaje a la lista inmediatamente para UI responsiva
    mensajes.add(mensajeUsuario);
    messageTextController.clear();

    // Guardar mensaje en el backend
    final guardado = await _mensajeService.guardarMensaje(mensajeUsuario);
    if (guardado) {
      print('>> [ChatController] Mensaje de usuario guardado en backend');
    } else {
      print(
          '>> [ChatController] Error guardando mensaje de usuario en backend');
    }

    // Simular respuesta del bot
    final respuestaBot = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch + 1,
      conversacion_id: conversacion!.conversacion_id,
      remitente: RemitenteType.ia,
      contenido_texto: 'Hola soy Broer-Bot, ¿en qué puedo ayudarte?',
      timestamp_envio: DateTime.now().add(const Duration(milliseconds: 200)),
    );

    // Agregar respuesta del bot con delay
    Future.delayed(const Duration(milliseconds: 300), () async {
      mensajes.add(respuestaBot);
      final guardadoBot = await _mensajeService.guardarMensaje(respuestaBot);
      if (guardadoBot) {
        print('>> [ChatController] Mensaje de IA guardado en backend');
      } else {
        print('>> [ChatController] Error guardando mensaje de IA en backend');
      }
    });
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
