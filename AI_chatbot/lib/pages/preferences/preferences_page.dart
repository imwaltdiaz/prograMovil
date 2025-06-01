// lib/pages/preferences/preferences_page.dart

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
          'Preferencias',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón para ir a Historial
              TextButton.icon(
                onPressed: controller.goToHistory,
                icon: const Icon(Icons.history),
                label: const Text('Historial de chat'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onBackground,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Botón para ir a Perfil
              TextButton.icon(
                onPressed: controller.goToProfile,
                icon: const Icon(Icons.person),
                label: const Text('Editar información'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onBackground,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),

              // Sección “Modelo IA por defecto”
              Text(
                'Modelo de IA predeterminado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de selección reactiva:
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

              const SizedBox(height: 24),

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
}
