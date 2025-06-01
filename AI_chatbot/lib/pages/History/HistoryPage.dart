// lib/pages/history/history_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';
import '../../models/conversacion.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Conversaciones',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorScheme.background,
      body: Obx(() {
        final lista = controller.conversaciones;

        if (lista.isEmpty) {
          return Center(
            child: Text(
              'No tienes conversaciones aún',
              style:
                  TextStyle(color: colorScheme.onBackground.withOpacity(0.6)),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lista.length,
          itemBuilder: (context, index) {
            final conversacion = lista[index] as Conversacion;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  conversacion.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  conversacion.fecha_creacion
                      .toLocal()
                      .toString()
                      .split(' ')[0],
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                onTap: () => controller.abrirConversacion(conversacion),
              ),
            );
          },
        );
      }),
    );
  }
}
