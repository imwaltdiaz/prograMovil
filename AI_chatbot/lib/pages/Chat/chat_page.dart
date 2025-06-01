// lib/pages/Chat/chat_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart'; // Tu ChatController
import '../../models/mensaje.dart'; // Aquí defines RemitenteType y Mensaje

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos (o recuperamos) el controlador
    final ChatController control = Get.put(ChatController());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget _buildBody() {
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (control.mensajes.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay mensajes',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                          color: isUser
                              ? colorScheme.primary
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.contenido_texto,
                          style: TextStyle(
                            color: isUser
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // ───────────────────────────────────────────────────────────────
            // Fila inferior: botón “Evaluar” a la izquierda, campo de texto y “Enviar”
            // ───────────────────────────────────────────────────────────────
            Container(
              color: colorScheme.background,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // 1) Botón “Evaluar” (icono) en la esquina inferior izquierda
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon:
                          Icon(Icons.rate_review, color: colorScheme.onPrimary),
                      tooltip: 'Evaluar respuesta',
                      onPressed: () {
                        // Abre la página de evaluación
                        Get.toNamed('/evaluation');
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 2) Campo de texto
                  Expanded(
                    child: TextField(
                      controller: control.messageTextController,
                      decoration: InputDecoration(
                        hintText: 'Escribe mensaje',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 3) Botón “Enviar”
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
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        // ─── Aquí reemplazamos el BackButton por un ícono de Logout ────
        leading: IconButton(
          icon: Icon(Icons.logout, color: colorScheme.onBackground),
          tooltip: 'Cerrar sesión',
          onPressed: () {
            // Volvemos a la pantalla de login (limpiando la pila de pantallas)
            Get.offAllNamed('/login');
          },
        ),
        title: Text(
          'Chat',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        // ─── Aquí agregamos el resto de iconos en el AppBar ────────────
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: colorScheme.onBackground),
            tooltip: 'Preferencias',
            onPressed: () {
              // Llamamos a la ruta de preferencias PASANDO el usuario actual
              Get.toNamed('/preferences', arguments: control.user);
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: colorScheme.onBackground),
            tooltip: 'Editar información',
            onPressed: () {
              // Abrir perfil pasando el usuario
              Get.toNamed('/profile', arguments: control.user);
            },
          ),
          IconButton(
            icon: Icon(Icons.history, color: colorScheme.onBackground),
            tooltip: 'Historial de chat',
            onPressed: () {
              // Abrir historial pasando el usuario
              Get.toNamed('/history', arguments: control.user);
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
