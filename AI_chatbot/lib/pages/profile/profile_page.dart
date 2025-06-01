// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Perfil',
          style: textTheme.titleLarge?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar circular
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Nombre
              TextField(
                controller: controller.txtName,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: textTheme.titleMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.person, color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 15),

              // Campo Correo
              TextField(
                controller: controller.txtEmail,
                keyboardType: TextInputType.emailAddress,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  labelStyle: textTheme.titleMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.email, color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 15),

              // Campo Teléfono
              TextField(
                controller: controller.txtPhone,
                keyboardType: TextInputType.phone,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  labelStyle: textTheme.titleMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.phone, color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 30),

              // Botón Guardar cambios usando colores del tema
              ElevatedButton(
                onPressed: () {
                  controller.saveProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Guardar cambios',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
