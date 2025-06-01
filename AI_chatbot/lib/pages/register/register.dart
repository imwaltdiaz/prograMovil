// lib/pages/register/register_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController controller = Get.put(RegisterController());

  Widget _form(BuildContext context) {
    // Obtenemos los estilos del tema global
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Título “Bienvenido”
          Text(
            'BIENVENIDO A AI CHATBOT',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Campo Email
          TextField(
            controller: controller.txtEmail,
            keyboardType: TextInputType.emailAddress,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: colorScheme.onSurface.withOpacity(0.5)),
              ),
              prefixIcon: Icon(Icons.email,
                  color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 15),

          // Campo Nombre
          TextField(
            controller: controller.txtName,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Nombre',
              labelStyle: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: colorScheme.onSurface.withOpacity(0.5)),
              ),
              prefixIcon: Icon(Icons.person,
                  color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 15),

          // Campo Contraseña
          TextField(
            controller: controller.txtPassword,
            obscureText: true,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: colorScheme.onSurface.withOpacity(0.5)),
              ),
              prefixIcon: Icon(Icons.lock,
                  color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 25),

          // Botón “Registrar”
          ElevatedButton(
            onPressed: () {
              controller.register(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Registrar',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 15),

          // Texto “o continúa con”
          Text(
            'o continúa con',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 15),

          // Botones de “Google” y “Apple”
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.g_mobiledata, color: colorScheme.onSurface),
                  label: Text(
                    'Google',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurface),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: colorScheme.onSurface.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: colorScheme.onSurface,
                    backgroundColor: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.apple, color: colorScheme.onSurface),
                  label: Text(
                    'Apple',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurface),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: colorScheme.onSurface.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: colorScheme.onSurface,
                    backgroundColor: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Texto “¿Ya tienes cuenta? Inicia sesión”
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onBackground),
              children: [
                const TextSpan(text: '¿Ya tienes cuenta? '),
                TextSpan(
                  text: 'Inicia sesión',
                  style: textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    color: colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      controller.goToLogin(context);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _layer1(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 50),
          _form(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _layer1(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Solo devolvemos el Scaffold (sin MaterialApp interno)
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }
}
