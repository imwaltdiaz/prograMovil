import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'preferences_controller.dart';
import '../../models/modelo_ia.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferencesController controller = Get.put(PreferencesController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Configuración',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección Perfil
              _buildSectionTitle('Perfil', colorScheme),
              const SizedBox(height: 12),
              _buildNavigationTile(
                icon: Icons.person,
                title: 'Editar información',
                onTap: controller.goToProfile,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // Sección Apariencia
              _buildSectionTitle('Apariencia', colorScheme),
              const SizedBox(height: 12),
              Obx(() {
                return Column(
                  children: [
                    _buildRadioTile(
                      title: 'Tema claro',
                      value: 'light',
                      groupValue: controller.selectedTheme.value,
                      onChanged: (value) =>
                          controller.selectedTheme.value = value!,
                      colorScheme: colorScheme,
                    ),
                    _buildRadioTile(
                      title: 'Tema oscuro',
                      value: 'dark',
                      groupValue: controller.selectedTheme.value,
                      onChanged: (value) =>
                          controller.selectedTheme.value = value!,
                      colorScheme: colorScheme,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),

              // Sección Chatbot
              _buildSectionTitle('Chatbot', colorScheme),
              const SizedBox(height: 12),

              // Modelo de IA predeterminado
              Text(
                'Modelo de IA predeterminado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final List<ModeloIA> lista = controller.modelosIA;
                final seleccionado = controller.modeloSeleccionado.value;

                return DropdownButton<ModeloIA>(
                  isExpanded: true,
                  value: seleccionado,
                  hint: const Text('Selecciona un modelo'),
                  items: lista.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m.nombre),
                    );
                  }).toList(),
                  onChanged: (nuevo) {
                    controller.modeloSeleccionado.value = nuevo;
                  },
                );
              }),
              const SizedBox(height: 16),

              // Estilo de respuesta
              _buildNavigationTile(
                icon: Icons.chat_bubble_outline,
                title: 'Estilo de respuesta',
                onTap: controller.goToResponseStyle,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),

              // Longitud preferida
              _buildNavigationTile(
                icon: Icons.format_size,
                title: 'Longitud preferida',
                onTap: controller.goToPreferredLength,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),

              // Historial de chat
              _buildNavigationTile(
                icon: Icons.history,
                title: 'Historial de chat',
                onTap: controller.goToHistory,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // Sección Notificaciones
              _buildSectionTitle('Notificaciones', colorScheme),
              const SizedBox(height: 12),
              Obx(() {
                return Column(
                  children: [
                    _buildSwitchTile(
                      title: 'Mensajes nuevos',
                      value: controller.newMessagesNotifications.value,
                      onChanged: (value) =>
                          controller.newMessagesNotifications.value = value,
                      colorScheme: colorScheme,
                    ),
                    _buildSwitchTile(
                      title: 'Actualizaciones',
                      value: controller.updatesNotifications.value,
                      onChanged: (value) =>
                          controller.updatesNotifications.value = value,
                      colorScheme: colorScheme,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),

              // Sección Privacidad
              _buildSectionTitle('Privacidad', colorScheme),
              const SizedBox(height: 12),
              _buildNavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Configuración de privacidad',
                onTap: controller.goToPrivacySettings,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // Botón Guardar + mensaje reactivo
              Obx(() {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: controller.guardarPreferencia,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Guardar cambios'),
                    ),
                    const SizedBox(height: 12),
                    if (controller.message.value.isNotEmpty)
                      Text(
                        controller.message.value,
                        style: TextStyle(
                          color: controller.messageColor.value,
                          fontSize: 14,
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onBackground.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required ColorScheme colorScheme,
  }) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: colorScheme.onBackground,
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme colorScheme,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: colorScheme.onBackground,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
