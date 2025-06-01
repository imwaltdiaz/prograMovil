import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'preferences_controller.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controlador
    final PreferencesController controller = Get.put(PreferencesController());

    // Extraemos los estilos del tema global
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Configuración',
          style: textTheme.titleLarge?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            // Sección: Perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Perfil',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Editar información',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onBackground),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: colorScheme.onSurface),
              onTap: () {
                controller.goToEditProfile(context);
              },
            ),
            ListTile(
              title: Text(
                'Historial de chat',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onBackground),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: colorScheme.onSurface),
              onTap: () {
                controller.goToHistory(context);
              },
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Sección: Apariencia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Apariencia',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            Obx(() => RadioListTile<bool>(
                  title: Text(
                    'Tema claro',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  value: false,
                  groupValue: controller.isDarkMode.value,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleTheme(value, context);
                    }
                  },
                )),
            Obx(() => RadioListTile<bool>(
                  title: Text(
                    'Tema oscuro',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  value: true,
                  groupValue: controller.isDarkMode.value,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleTheme(value, context);
                    }
                  },
                )),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Sección: Chatbot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Chatbot',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Estilo de respuesta',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onBackground),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: colorScheme.onSurface),
              onTap: () {
                controller.goToResponseStyle(context);
              },
            ),
            ListTile(
              title: Text(
                'Longitud preferida',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onBackground),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: colorScheme.onSurface),
              onTap: () {
                controller.goToPreferredLength(context);
              },
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Sección: Notificaciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Notificaciones',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            Obx(() => CheckboxListTile(
                  title: Text(
                    'Mensajes nuevos',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  value: controller.notifyNewMessages.value,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleNewMessages(value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                )),
            Obx(() => CheckboxListTile(
                  title: Text(
                    'Actualizaciones',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  value: controller.notifyUpdates.value,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleUpdates(value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
