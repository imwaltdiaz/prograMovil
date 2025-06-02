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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Configuración',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Sección Perfil ─────────────────────────────────────────────
              Text(
                'Perfil',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              _buildNavigationTile(
                icon: Icons.person,
                title: 'Editar información',
                onTap: controller.goToProfile,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // ─── Sección Chatbot / Modelo IA ─────────────────────────────────
              Text(
                'Chatbot',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              _buildNavigationTile(
                icon: Icons.memory,
                title: 'Modelo de IA predeterminado',
                onTap: controller.goToAIConfig,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // ─── Sección Historial ────────────────────────────────────────────
              Text(
                'Historial',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              _buildNavigationTile(
                icon: Icons.history,
                title: 'Historial de chat',
                onTap: controller.goToHistory,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // ─── Mensaje reactivo de confirmación/error ───────────────────────
              Obx(() {
                if (controller.message.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: controller.messageColor.value.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.message.value,
                    style: TextStyle(
                      color: controller.messageColor.value,
                      fontSize: 14,
                    ),
                  ),
                );
              }),

              // ─── (Opcional) Botón “Guardar modelo IA” si quisieras mostrar combo aquí ─
              // ElevatedButton(
              //   onPressed: controller.guardarPreferencia,
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size(double.infinity, 48),
              //     backgroundColor: colorScheme.primary,
              //     foregroundColor: colorScheme.onPrimary,
              //   ),
              //   child: const Text('Guardar modelo IA'),
              // ),
            ],
          ),
        ),
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
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
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
}
