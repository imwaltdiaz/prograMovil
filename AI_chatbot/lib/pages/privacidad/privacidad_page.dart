import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Privacidad',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Política de Privacidad del Chat',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tu privacidad es importante para nosotros. '
                        'Este chat utiliza tus datos únicamente para mejorar la experiencia del usuario. '
                        'No compartimos tus conversaciones con terceros y mantenemos tu información segura en todo momento.\n\n'
                        'Datos recopilados:\n'
                        '- Contenido de tus mensajes.\n'
                        '- Preferencias de uso.\n\n'
                        'Uso de la información:\n'
                        '- Mejorar las respuestas del chatbot.\n'
                        '- Analizar patrones de uso para mejoras futuras.\n\n'
                        'Al utilizar este servicio, aceptas nuestra política de privacidad. '
                        'Si tienes alguna pregunta o inquietud, puedes contactarnos a través de nuestro soporte técnico.\n\n'
                        'Última actualización: 01 de Junio de 2025.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botón de Aceptar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Volver a la pantalla anterior
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(fontSize: 16),
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
