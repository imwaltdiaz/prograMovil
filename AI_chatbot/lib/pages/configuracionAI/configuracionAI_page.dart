import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'configuracionAI_controller.dart';
import '../../models/modelo_ia.dart';

// Color marrón personalizado
const Color customPrimaryColor = Color(0xFF8B4513); // <- Marrón consistente

class AIConfigPage extends StatelessWidget {
  const AIConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AIConfigController ctrl = Get.put(AIConfigController());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Configuración de IA',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Proveedor ───────────────────────────────────────────
            Text(
              'Proveedor:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Column(
                children: AIProvider.values.map((prov) {
                  final label = _labelForProvider(prov);
                  return RadioListTile<AIProvider>(
                    title: Text(label, style: textTheme.bodyMedium),
                    value: prov,
                    groupValue: ctrl.selectedProvider.value,
                    activeColor: customPrimaryColor, // Color marrón
                    onChanged: (v) {
                      if (v != null) ctrl.onProviderChanged(v);
                    },
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),

            // ─── Modelo ──────────────────────────────────────────────
            Text(
              'Modelo:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final listaModelos = ctrl.availableModelObjects.toList();
              if (listaModelos.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: colorScheme.onSurface.withOpacity(0.1)),
                  ),
                  child: Text(
                    'No hay modelos activos para este proveedor.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                );
              }

              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: ctrl.selectedModelKey.value,
                  hint: Text(
                    'Selecciona un modelo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
                  underline: const SizedBox.shrink(),
                  dropdownColor: colorScheme.surface,
                  items: listaModelos.map((ModeloIA m) {
                    return DropdownMenuItem<String>(
                      value: m.identificador_interno_modelo,
                      child: Text(m.nombre, style: textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: ctrl.onModelChanged,
                ),
              );
            }),
            const SizedBox(height: 24),

            // ─── API Key ─────────────────────────────────────────────
            Text(
              'API Key:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return TextField(
                controller: ctrl.apiKeyController,
                obscureText: !ctrl.isApiKeyVisible.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                  hintText: 'Ingresa tu API Key',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      ctrl.isApiKeyVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      ctrl.isApiKeyVisible.toggle();
                    },
                  ),
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              );
            }),
            const SizedBox(height: 24),

            // ─── Parámetros ──────────────────────────────────────────
            Text(
              'Parámetros:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Temperatura
            Row(
              children: [
                Text('Temperatura:', style: textTheme.bodyMedium),
                const SizedBox(width: 8),
                Obx(() {
                  return Text(
                    ctrl.temperature.value.toStringAsFixed(1),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: customPrimaryColor, // Marrón en temperatura
                    ),
                  );
                }),
              ],
            ),
            Obx(() {
              return SliderTheme(
                data: Theme.of(context).sliderTheme.copyWith(
                      activeTrackColor: customPrimaryColor,
                      inactiveTrackColor: customPrimaryColor.withOpacity(0.3),
                      thumbColor: customPrimaryColor,
                      overlayColor: customPrimaryColor.withAlpha(32),
                    ),
                child: Slider(
                  value: ctrl.temperature.value,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: ctrl.temperature.value.toStringAsFixed(1),
                  onChanged: ctrl.onTemperatureChanged,
                ),
              );
            }),
            const SizedBox(height: 20),

            // Max Tokens
            Row(
              children: [
                Text('Max tokens:', style: textTheme.bodyMedium),
                const SizedBox(width: 8),
                Obx(() {
                  return Text(
                    ctrl.maxTokens.value.round().toString(),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: customPrimaryColor, // Marrón en tokens
                    ),
                  );
                }),
              ],
            ),
            Obx(() {
              return SliderTheme(
                data: Theme.of(context).sliderTheme.copyWith(
                      activeTrackColor: customPrimaryColor,
                      inactiveTrackColor: customPrimaryColor.withOpacity(0.3),
                      thumbColor: customPrimaryColor,
                      overlayColor: customPrimaryColor.withAlpha(32),
                    ),
                child: Slider(
                  value: ctrl.maxTokens.value,
                  min: 256,
                  max: 8192,
                  divisions: (8192 - 256) ~/ 256,
                  label: ctrl.maxTokens.value.round().toString(),
                  onChanged: ctrl.onMaxTokensChanged,
                ),
              );
            }),
            const SizedBox(height: 36),

            // ─── Botón “Guardar” ─────────────────────────────────────
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
                label: Text(
                  'GUARDAR',
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
                onPressed: () => ctrl.saveConfig(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPrimaryColor, // Marrón consistente
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  textStyle: textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: customPrimaryColor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Traduce cada valor de la enumeración AIProvider a un texto legible.
  String _labelForProvider(AIProvider p) {
    switch (p) {
      case AIProvider.openAI:
        return 'OpenAI';
      case AIProvider.azureOpenAI:
        return 'Azure OpenAI';
      case AIProvider.anthropic:
        return 'Anthropic';
      case AIProvider.googleGemini:
        return 'Google Gemini';
    }
  }
}
