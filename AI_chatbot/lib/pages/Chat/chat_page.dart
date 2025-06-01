// lib/pages/Chat/chat_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart'; // Ajusta la ruta si tu carpeta se llama "Chat"

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos con GetX nuestro controlador
    final ChatController control = Get.put(ChatController());

    // Accedemos al TextTheme y ColorScheme del tema global
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget _buildBody() {
      return SafeArea(
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  itemCount: control.messages.length,
                  itemBuilder: (context, index) {
                    final msg = control.messages[index];
                    final isUser = (msg['sender'] == 'user');

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? colorScheme.primary
                              : colorScheme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isUser
                                ? colorScheme.onPrimary
                                : colorScheme.onSecondary,
                            fontSize: 15,
                            fontFamily: textTheme.bodyMedium?.fontFamily,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Barra de entrada + botón enviar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              color: colorScheme.background,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: control.messageTextController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Escribe mensaje',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: colorScheme.onSurface, width: 1),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: colorScheme.onPrimary),
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
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Nueva conversación',
          style: textTheme.titleLarge?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // Tres iconos en la esquina superior derecha:
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => control.goToPreferences(context),
            tooltip: 'Preferencias',
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () => control.goToHistory(context),
            tooltip: 'Historial',
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () => control.goToProfile(context),
            tooltip: 'Perfil',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
