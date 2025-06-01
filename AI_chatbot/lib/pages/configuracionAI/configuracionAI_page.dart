import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de IA',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, // For back button and title color
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Provider Selection Section
            const Text(
              'Proveedor actual:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            _buildProviderRadioListTile(AIProvider.openAI, 'OpenAI'),
            _buildProviderRadioListTile(AIProvider.azureOpenAI, 'Azure OpenAI'),
            _buildProviderRadioListTile(AIProvider.anthropic, 'Anthropic'),
            _buildProviderRadioListTile(
                AIProvider.googleGemini, 'Google Gemini'),
            const SizedBox(height: 25),

            // Model Selection Section
            const Text(
              'Modelo:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            if (_currentModels
                .isNotEmpty) // Only show dropdown if models are available
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[350]!, width: 1),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedModel,
                  icon: const Icon(Icons.arrow_drop_down_rounded,
                      color: Colors.black54),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  items: _currentModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[350]!, width: 1),
                ),
                child: const Text("Seleccione un proveedor para ver modelos.",
                    style: TextStyle(color: Colors.black54)),
              ),
            const SizedBox(height: 25),

            // API Key Section
            const Text(
              'API Key:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
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
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    // Basic toggle, for a real app, manage obscureText state
                    // For simplicity, this just clears and re-adds the placeholder
                    final currentText = _apiKeyController.text;
                    // This is a placeholder for actual visibility toggle logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Toggle visibility (not fully implemented)')),
                    );
                  },
                ),
              ),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 25),

            // Parameters Section
            const Text(
              'Parámetros:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 15),
            // Temperature Slider
            Row(
              children: [
                const Text('Temperatura:',
                    style: TextStyle(fontSize: 15, color: Colors.black87)),
                const SizedBox(width: 5),
                Text(_temperature.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal)),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.teal.withOpacity(0.3),
                trackHeight: 6.0,
                thumbColor: Colors.teal,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                overlayColor: Colors.teal.withAlpha(32),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 20.0),
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

            // Max Tokens Slider
            Row(
              children: [
                const Text('Max tokens:',
                    style: TextStyle(fontSize: 15, color: Colors.black87)),
                const SizedBox(width: 5),
                Text(_maxTokens.round().toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal)),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.teal.withOpacity(0.3),
                trackHeight: 6.0,
                thumbColor: Colors.teal,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                overlayColor: Colors.teal.withAlpha(32),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 20.0),
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

            // Save Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
                label: const Text('GUARDAR',
                    style: TextStyle(color: Colors.white)),
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
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.teal.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderRadioListTile(AIProvider provider, String title) {
    return RadioListTile<AIProvider>(
      title: Text(title,
          style: const TextStyle(fontSize: 15, color: Colors.black87)),
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
      activeColor: Colors.teal,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
