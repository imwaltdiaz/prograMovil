import 'package:flutter/material.dart';

<<<<<<< Updated upstream
// AIConfigScreen remains largely the same, but it's now a separate route
class AIConfigScreen extends StatefulWidget {
  const AIConfigScreen({super.key});

  @override
  State<AIConfigScreen> createState() => _AIConfigScreenState();
}

enum AIProvider { openAI, azureOpenAI, anthropic, googleGemini }

class _AIConfigScreenState extends State<AIConfigScreen> {
  AIProvider? _selectedProvider = AIProvider.openAI;
  String? _selectedModel = 'gpt-4o';
  final TextEditingController _apiKeyController =
      TextEditingController(text: '••••••••••••');
  double _temperature = 0.7;
  double _maxTokens = 4096;

  // Example models - you might want to make these dynamic based on provider
  final Map<AIProvider, List<String>> _providerModels = {
    AIProvider.openAI: ['gpt-4o', 'gpt-4', 'gpt-3.5-turbo'],
    AIProvider.azureOpenAI: ['azure-gpt-4o', 'azure-gpt-35-turbo'],
    AIProvider.anthropic: ['claude-3-opus', 'claude-3-sonnet', 'claude-2.1'],
    AIProvider.googleGemini: ['gemini-1.5-pro', 'gemini-1.0-pro'],
  };

  List<String> _currentModels = [];

  @override
  void initState() {
    super.initState();
    // Initialize models based on the default selected provider
    _updateModelsForProvider(_selectedProvider!);
    _apiKeyController.text = '••••••••••••'; // Default placeholder
  }

  void _updateModelsForProvider(AIProvider provider) {
    setState(() {
      _currentModels = _providerModels[provider] ?? [];
      // If the current selected model is not in the new list, reset it
      if (!_currentModels.contains(_selectedModel)) {
        _selectedModel =
            _currentModels.isNotEmpty ? _currentModels.first : null;
      }
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
=======
// Color marrón personalizado
const Color customPrimaryColor = Color(0xFF8B4513); // <- Marrón consistente

class AIConfigPage extends StatelessWidget {
  const AIConfigPage({super.key});
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de IA',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Provider Selection Section
            Text(
              'Proveedor actual:',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
<<<<<<< Updated upstream
            _buildProviderRadioListTile(
                AIProvider.openAI, 'OpenAI', colorScheme.secondary),
            _buildProviderRadioListTile(
                AIProvider.azureOpenAI, 'Azure OpenAI', colorScheme.secondary),
            _buildProviderRadioListTile(
                AIProvider.anthropic, 'Anthropic', colorScheme.secondary),
            _buildProviderRadioListTile(AIProvider.googleGemini,
                'Google Gemini', colorScheme.secondary),
            const SizedBox(height: 25),
=======
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
>>>>>>> Stashed changes

            // Model Selection Section
            Text(
              'Modelo:',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            if (_currentModels
                .isNotEmpty) // Only show dropdown if models are available
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant, // Example grey
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      color: colorScheme.onSurface.withOpacity(0.1), width: 1),
                ),
<<<<<<< Updated upstream
                child: DropdownButtonFormField<String>(
                  value: _selectedModel,
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      color: textTheme.bodyMedium?.color?.withOpacity(0.7)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
=======
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: ctrl.selectedModelKey.value,
                  hint: Text(
                    'Selecciona un modelo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                    ),
>>>>>>> Stashed changes
                  ),
                  dropdownColor: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  items: _currentModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model, style: textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedModel = newValue;
                    });
                  },
                  isExpanded: true,
                ),
              )
            else
              Container(
                // Placeholder if no models are available for the selected provider
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      color: colorScheme.onSurface.withOpacity(0.1), width: 1),
                ),
                child: Text("Seleccione un proveedor para ver modelos.",
                    style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7))),
              ),
            const SizedBox(height: 25),

            // API Key Section
            Text(
              'API Key:',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
<<<<<<< Updated upstream
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceVariant,
                hintText: 'Ingresa tu API Key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Simple toggle, ideally you'd manage obscureText state
                    Icons.visibility_off_outlined,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    // Basic toggle, for a real app, manage obscureText state
                    // For simplicity, this just clears and re-adds the placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Toggle visibility (not fully implemented)')),
                    );
                  },
                ),
              ),
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 25),
=======
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
>>>>>>> Stashed changes

            // Parameters Section
            Text(
              'Parámetros:',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            // Temperature Slider
            Row(
              children: [
                Text('Temperatura:', style: textTheme.bodyMedium),
                const SizedBox(width: 5),
                Text(_temperature.toStringAsFixed(1),
                    style: textTheme.bodyMedium?.copyWith(
<<<<<<< Updated upstream
                        fontWeight: FontWeight.w500,
                        color: colorScheme.secondary)),
              ],
            ),
            SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    activeTrackColor: colorScheme.secondary,
                    inactiveTrackColor: colorScheme.secondary.withOpacity(0.3),
                    thumbColor: colorScheme.secondary,
                    overlayColor: colorScheme.secondary.withAlpha(32),
                  ),
              child: Slider(
                value: _temperature,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: _temperature.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _temperature = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
=======
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
>>>>>>> Stashed changes

            // Max Tokens Slider
            Row(
              children: [
                Text('Max tokens:', style: textTheme.bodyMedium),
                const SizedBox(width: 5),
                Text(_maxTokens.round().toString(),
                    style: textTheme.bodyMedium?.copyWith(
<<<<<<< Updated upstream
                        fontWeight: FontWeight.w500,
                        color: colorScheme.secondary)),
              ],
            ),
            SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    activeTrackColor: colorScheme.secondary,
                    inactiveTrackColor: colorScheme.secondary.withOpacity(0.3),
                    thumbColor: colorScheme.secondary,
                    overlayColor: colorScheme.secondary.withAlpha(32),
                  ),
              child: Slider(
                value: _maxTokens,
                min: 256,
                max: 8192,
                divisions: (8192 - 256) ~/ 256,
                label: _maxTokens.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _maxTokens = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
=======
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
>>>>>>> Stashed changes

            // Save Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
                label: Text('GUARDAR',
                    style: textTheme.labelLarge?.copyWith(color: Colors.white)),
                onPressed: () {
                  // Implement save logic here
                  final providerName =
                      _selectedProvider.toString().split('.').last;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Configuración guardada: Provider: $providerName, Model: $_selectedModel, Temp: $_temperature, Tokens: ${_maxTokens.round()}'),
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(10),
                      elevation: 6,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPrimaryColor, // Marrón consistente
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
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

  Widget _buildProviderRadioListTile(
      AIProvider provider, String title, Color activeColor) {
    return RadioListTile<AIProvider>(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      value: provider,
      groupValue: _selectedProvider,
      onChanged: (AIProvider? value) {
        if (value != null) {
          setState(() {
            _selectedProvider = value;
            _updateModelsForProvider(
                value); // Update models when provider changes
          });
        }
      },
      activeColor: activeColor,
      // Removed invalid radioListTileTheme usage
      // You can set contentPadding directly if needed, e.g.:
      // contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      // dense: false,
    );
  }
}
