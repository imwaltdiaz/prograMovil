// lib/pages/Chat/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <Map<String, String>>[].obs;
  final messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Mensaje inicial de la IA
    messages.add({
      'sender': 'ia',
      'text': 'Hola, ¿en qué puedo ayudarte hoy?',
    });
  }

  void sendMessage() {
    final text = messageTextController.text.trim();
    if (text.isEmpty) return;

    // Mensaje del usuario
    messages.add({'sender': 'user', 'text': text});
    messageTextController.clear();

    // Respuesta simulada de la IA
    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add({
        'sender': 'ia',
        'text':
            'Por supuesto, cuéntame qué problema tienes y trataré de ayudarte.',
      });
    });
  }

  /// Navegar a Preferencias
  void goToPreferences(BuildContext context) {
    Navigator.pushNamed(context, '/preferences');
  }

  /// Navegar a Historial
  void goToHistory(BuildContext context) {
    Navigator.pushNamed(context, '/history');
  }

  /// Navegar a Perfil
  void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  @override
  void onClose() {
    messageTextController.dispose();
    super.onClose();
  }
}
