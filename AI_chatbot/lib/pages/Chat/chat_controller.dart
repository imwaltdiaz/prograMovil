// lib/pages/chat/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/mensaje.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import '../../services/mensaje_service.dart';

class ChatController extends GetxController {
  final MensajeService _mensajeService = MensajeService();

  late final Usuario user;
  late final Conversacion conversacion;

  var mensajes = <Mensaje>[].obs;
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
      Get.back();
    }
  }

  Future<void> _cargarMensajesDeConversacion(int converId) async {
    final lista = await _mensajeService.getMensajesPorConversacion(converId);
    mensajes.assignAll(lista);
  }

  Future<void> sendMessage() async {
    final texto = messageTextController.text.trim();
    if (texto.isEmpty) return;

    final mensajeUsuario = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch,
      conversacion_id: conversacion.conversacion_id,
      remitente: RemitenteType.usuario,
      contenido_texto: texto,
      timestamp_envio: DateTime.now(),
    );
    mensajes.add(mensajeUsuario);
    await _mensajeService.guardarMensaje(mensajeUsuario);
    messageTextController.clear();

    final respuestaBot = Mensaje(
      mensaje_id: DateTime.now().millisecondsSinceEpoch + 1,
      conversacion_id: conversacion.conversacion_id,
      remitente: RemitenteType.ia,
      contenido_texto: 'Este es un mensaje predeterminado del modelo IA.',
      timestamp_envio: DateTime.now().add(const Duration(milliseconds: 200)),
    );
    Future.delayed(const Duration(milliseconds: 300), () async {
      mensajes.add(respuestaBot);
      await _mensajeService.guardarMensaje(respuestaBot);
    });
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }
}
