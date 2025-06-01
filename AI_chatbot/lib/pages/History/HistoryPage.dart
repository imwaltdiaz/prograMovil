import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/conversacion.dart';
import '../../models/user.dart';
import 'history_controller.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Instanciar el controller (esto ejecutará onInit() con el print)
    final HistoryController controller = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        title: Text(
          'Conversaciones',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: colorScheme.primary));
        }

        if (controller.conversaciones.isEmpty) {
          return Center(
            child: Text(
              'No hay conversaciones',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.5),
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: controller.refrescar,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: controller.conversaciones.length,
            itemBuilder: (context, index) {
              final Conversacion conv = controller.conversaciones[index];
              final fecha = DateFormat('yyyy-MM-dd')
                  .format(conv.fecha_creacion.toLocal());

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    conv.titulo,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      fecha,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ),
                  onTap: () {
                    print(
                        '>> [HistoryPage] Tocó conversación id=${conv.conversacion_id}');
                    Get.toNamed(
                      '/chat',
                      arguments: {
                        'user': controller.user,
                        'conversacion': conv,
                      },
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.share, color: colorScheme.primary),
                    tooltip: 'Compartir conversación',
                    onPressed: () {
                      Navigator.pushNamed(context, '/compartir',
                          arguments: conv);
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
