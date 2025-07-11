// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controller que ya carga el Usuario desde Get.arguments
    final ProfileController controller = Get.put(ProfileController());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Perfil',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Nos aseguramos de que el usuario esté inicializado en el controller
        final Usuario user = controller.user;

        // --- Avatar con Image.network + errorBuilder ---
        Widget avatarWidget;
        final url = user.imagen_url ?? '';
        if (url.isNotEmpty) {
          avatarWidget = ClipOval(
            child: Image.network(
              url,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              // Si falla la descarga, entramos aquí y mostramos el ícono de persona
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          );
        } else {
          // Si la URL está vacía, dibujamos directamente el ícono
          avatarWidget = CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.surfaceVariant,
            child: Icon(
              Icons.person,
              size: 60,
              color: colorScheme.onSurfaceVariant,
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // ─── Avatar (imagen de URL con fallback) ─────────────────
                Center(child: avatarWidget),

                const SizedBox(height: 24),

                // ─── Campo NOMBRE ───────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nombre',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.txtName,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person, color: colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Campo CORREO ──────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Correo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.txtEmail,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Campo FECHA DE REGISTRO (no editable) ─────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fecha de registro',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(
                    controller.fechaRegistroValue.value,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Botón “Guardar cambios” ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value 
                        ? null 
                        : () {
                            controller.saveProfile();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Guardar cambios',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )),
                ),

                const SizedBox(height: 16),

                // ─── Mensaje de éxito/error (si aplica) ─────────────────
                Obx(() {
                  if (controller.message.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: controller.messageColor.value.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.message.value,
                      style: textTheme.bodyMedium?.copyWith(
                        color: controller.messageColor.value,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
