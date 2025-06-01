// lib/pages/chat/chat_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart'; // Importa el controlador
import '../../models/mensaje.dart'; // Para el enum RemitenteType
import '../../models/conversacion.dart'; // Clase Conversacion
import '../../models/user.dart'; // Clase Usuario

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controlador con Get.put()
    final ChatController control = Get.put(ChatController());

    Widget _buildBody() {
      return SafeArea(
        child: Column(
          children: [
            // Si no hay mensajes, mostramos “No hay mensajes”
            Obx(() {
              if (control.mensajes.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'No hay mensajes',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
              // Lista de mensajes
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  itemCount: control.mensajes.length,
                  itemBuilder: (context, index) {
                    final msg = control.mensajes[index];
                    final isUser = msg.remitente == RemitenteType.usuario;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.indigo : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.contenido_texto,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // Línea de entrada de texto + botón “Enviar”
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: control.messageTextController,
                      decoration: InputDecoration(
                        hintText: 'Escribe mensaje',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        control.sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // Botones rápidos para Perfil, Historial y Preferencias:
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            tooltip: 'Ver perfil',
            onPressed: () {
              Get.toNamed('/profile', arguments: control.user);
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            tooltip: 'Historial',
            onPressed: () {
              Get.toNamed('/history', arguments: control.user);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            tooltip: 'Preferencias',
            onPressed: () {
              Get.toNamed('/preferences', arguments: control.user);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
