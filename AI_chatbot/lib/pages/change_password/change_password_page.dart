// lib/pages/change_password/change_password_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController controller = Get.put(
      ChangePasswordController(),
      permanent: false,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Cambiar Contraseña',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Icono de seguridad
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.security,
                  size: 40,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Por tu seguridad, ingresa tu contraseña actual y luego tu nueva contraseña.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ─── Campo CONTRASEÑA ACTUAL ─────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Contraseña Actual',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.txtCurrentPassword,
                    obscureText: !controller.showCurrentPassword.value,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.lock, color: colorScheme.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showCurrentPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          controller.showCurrentPassword.value =
                              !controller.showCurrentPassword.value;
                        },
                      ),
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
                  )),

              const SizedBox(height: 20),

              // ─── Campo NUEVA CONTRASEÑA ─────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nueva Contraseña',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.txtNewPassword,
                    obscureText: !controller.showNewPassword.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline,
                          color: colorScheme.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showNewPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          controller.showNewPassword.value =
                              !controller.showNewPassword.value;
                        },
                      ),
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
                  )),

              const SizedBox(height: 20),

              // ─── Campo CONFIRMAR NUEVA CONTRASEÑA ─────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirmar Nueva Contraseña',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.txtConfirmPassword,
                    obscureText: !controller.showConfirmPassword.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline,
                          color: colorScheme.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          controller.showConfirmPassword.value =
                              !controller.showConfirmPassword.value;
                        },
                      ),
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
                  )),

              const SizedBox(height: 32),

              // ─── Botón "Cambiar contraseña" ────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.changePassword();
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Cambiar Contraseña',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )),
              ),

              const SizedBox(height: 16),

              // ─── Mensaje de éxito/error ─────────────────────────────────
              Obx(() {
                if (controller.message.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: controller.messageColor.value.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.messageColor.value.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    controller.message.value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: controller.messageColor.value,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Consejos de seguridad
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consejos para una contraseña segura:',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Al menos 6 caracteres\n'
                      '• Combina letras y números\n'
                      '• Usa caracteres especiales\n'
                      '• No uses información personal',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
