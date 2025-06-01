// lib/pages/chat/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/mensaje.dart'; // Enum y clase Mensaje
import '../../models/conversacion.dart'; // Clase Conversacion
import '../../models/user.dart'; // Clase Usuario
import '../../services/mensaje_service.dart'; // MensajeService que lee/guarda en JSON

class ChatController extends GetxController {
  final MensajeService _mensajeService = MensajeService();

  /// El usuario que inició sesión (viene en Get.arguments['user'])
  late final Usuario user;

  /// La conversación activa (viene en Get.arguments['conversacion'])
  late final Conversacion conversacion;

  /// Lista reactiva de Mensaje para la conversación actual
  var mensajes = <Mensaje>[].obs;

  /// Controller para el TextField de entrada de texto
  final TextEditingController messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      user = args['user'] as Usuario;
      conversacion = args['conversacion'] as Conversacion;
      _cargarMensajesDeConversacion(conversacion.conversacion_id);
    } else {
      // Si no se recibieron argumentos válidos, volvemos atrás
      mensajes.clear();
      Get.back();
    }
  }

  Future<void> _cargarMensajesDeConversacion(int convId) async {
    final lista = await _mensajeService.getMensajesPorConversacion(convId);
    mensajes.assignAll(lista);
  }

  Future<void> sendMessage() async {
    final texto = messageTextController.text.trim();
    if (texto.isEmpty) return;

    final nuevoMensaje = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch,
      conversacion_id: conversacion.conversacion_id,
      remitente: RemitenteType.usuario, // Aquí usamos el enum, no 'String'
      contenido_texto: texto,
      timestamp_envio: DateTime.now(), // Aquí pasamos DateTime, no String
    );

    await _mensajeService.guardarMensaje(nuevoMensaje);
    mensajes.add(nuevoMensaje);
    messageTextController.clear();
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }
}
