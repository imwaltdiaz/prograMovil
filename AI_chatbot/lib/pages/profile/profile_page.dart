// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Perfil',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Avatar / ícono de usuario
              CircleAvatar(
                radius: 48,
                backgroundColor: colorScheme.onBackground.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 48,
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),

              // Campo Nombre
              TextField(
                controller: controller.txtName,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),
              const SizedBox(height: 16),

              // Campo Correo
              TextField(
                controller: controller.txtEmail,
                readOnly: true, // Quizá no quieras que puedan cambiar el email
                decoration: InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),
              const SizedBox(height: 16),

              // Mostrar fecha de registro
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha de registro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      child: Text(
                        controller.fechaRegistroValue.value,
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 32),

              // Botón Guardar cambios + mensaje reactivo
              Obx(() {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Guardar cambios'),
                    ),
                    const SizedBox(height: 12),
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
              const SizedBox(height: 24),

              // Botón para regresar a preferencias
              TextButton(
                onPressed: controller.goToPreferences,
                child: Text(
                  'Volver a Preferencias',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
