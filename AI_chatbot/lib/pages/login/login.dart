import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());

  Widget _form(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Título de la pantalla
          Text(
            'AI CHATBOT',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Campo Email
          TextField(
            controller: controller.txtUser,
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

          // Botón “Ingresar”
          ElevatedButton(
            onPressed: () {
              controller.login(context);
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
              'Ingresar',
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

          // Botones “Google” y “Apple”
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

          // Texto “¿No tienes cuenta? Regístrate”
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onBackground),
              children: [
                const TextSpan(text: '¿No tienes cuenta? '),
                TextSpan(
                  text: 'Regístrate',
                  style: textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    color: colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      controller.goToRegister(context);
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }
}
