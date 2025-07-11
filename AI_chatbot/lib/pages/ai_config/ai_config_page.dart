import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ai_config_controller.dart';
import '../../models/modelo_ia.dart';

class AIConfigPage extends StatelessWidget {
  const AIConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AIConfigController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: BackButton(color: colorScheme.onBackground),
        title: Text(
          'Configuración de IA',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Sección Proveedor ─────────────────────────────
              _buildSectionTitle('Proveedor:', textTheme, colorScheme),
              const SizedBox(height: 12),

              // Lista de proveedores
              ...controller.proveedores.map(
                (proveedor) => Obx(() => RadioListTile<String>(
                      title: Text(proveedor),
                      value: proveedor,
                      groupValue: controller.proveedorSeleccionado.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.cambiarProveedor(value);
                        }
                      },
                      activeColor: colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    )),
              ),

              const SizedBox(height: 24),

              // ─── Sección Modelo ─────────────────────────────
              _buildSectionTitle('Modelo:', textTheme, colorScheme),
              const SizedBox(height: 12),

              Obx(() => Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ModeloIA>(
                        value: controller.modeloSeleccionado.value,
                        isExpanded: true,
                        hint: Text('Selecciona un modelo'),
                        items: controller.modelosDisponibles
                            .map((modelo) => DropdownMenuItem<ModeloIA>(
                                  value: modelo,
                                  child: Text(
                                      '${modelo.nombre} (${modelo.proveedor})'),
                                ))
                            .toList(),
                        onChanged: (ModeloIA? modelo) {
                          controller.cambiarModelo(modelo);
                        },
                        icon: Icon(Icons.arrow_drop_down,
                            color: colorScheme.primary),
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // ─── Sección API Key ─────────────────────────────
              _buildSectionTitle('API Key:', textTheme, colorScheme),
              const SizedBox(height: 12),

              Obx(() => TextField(
                    controller: TextEditingController(
                        text: controller.apiKey.value)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.apiKey.value.length),
                      ),
                    onChanged: (value) => controller.apiKey.value = value,
                    obscureText: !controller.apiKeyVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu API Key',
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.apiKeyVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: colorScheme.primary,
                        ),
                        onPressed: controller.toggleApiKeyVisibility,
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // ─── Sección Parámetros ─────────────────────────────
              _buildSectionTitle('Parámetros:', textTheme, colorScheme),
              const SizedBox(height: 16),

              // Temperatura
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Temperatura:', style: textTheme.bodyMedium),
                          Text(
                            controller.temperatura.value.toStringAsFixed(1),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colorScheme.primary,
                          inactiveTrackColor:
                              colorScheme.primary.withOpacity(0.3),
                          thumbColor: colorScheme.primary,
                          overlayColor: colorScheme.primary.withOpacity(0.2),
                          valueIndicatorColor: colorScheme.primary,
                        ),
                        child: Slider(
                          value: controller.temperatura.value,
                          min: 0.0,
                          max: 2.0,
                          divisions: 20,
                          onChanged: controller.updateTemperatura,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 16),

              // Max Tokens
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Max tokens:', style: textTheme.bodyMedium),
                          Text(
                            controller.maxTokens.value.toString(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colorScheme.primary,
                          inactiveTrackColor:
                              colorScheme.primary.withOpacity(0.3),
                          thumbColor: colorScheme.primary,
                          overlayColor: colorScheme.primary.withOpacity(0.2),
                          valueIndicatorColor: colorScheme.primary,
                        ),
                        child: Slider(
                          value: controller.maxTokens.value.toDouble(),
                          min: 256,
                          max: 8192,
                          divisions: 31,
                          onChanged: controller.updateMaxTokens,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 32),

              // ─── Mensaje de estado ─────────────────────────────
              Obx(() {
                if (controller.message.value.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: controller.isSuccess.value
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.isSuccess.value
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Text(
                      controller.message.value,
                      style: TextStyle(
                        color: controller.isSuccess.value
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // ─── Botón Guardar ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.guardarConfiguracion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('GUARDAR'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(
      String title, TextTheme textTheme, ColorScheme colorScheme) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        color: colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
