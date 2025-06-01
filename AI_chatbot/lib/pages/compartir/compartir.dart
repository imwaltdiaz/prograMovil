// lib/pages/compartir/compartir.dart

import 'package:flutter/material.dart';

class CompartirPage extends StatefulWidget {
  const CompartirPage({super.key});

  @override
  State<CompartirPage> createState() => _CompartirPageState();
}

class _CompartirPageState extends State<CompartirPage> {
  // 0 = Texto plano, 1 = Imagen, 2 = Enlace (próx.)
  int _selectedFormat = 1;

  bool _includePreguntas = true;
  bool _includeRespuestas = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context)
          .scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          'Compartir conversación',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ======= Seleccionar Formato =======
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Seleccionar formato:',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),

            // Opción: Texto plano
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface, // Use theme surface color
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: RadioListTile<int>(
                value: 0,
                groupValue: _selectedFormat,
                title: Text(
                  'Texto plano',
                  style: textTheme.bodyMedium,
                ),
                activeColor:
                    colorScheme.primary, // Using primary color from theme
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Opción: Imagen
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: RadioListTile<int>(
                value: 1,
                groupValue: _selectedFormat,
                title: Text(
                  'Imagen',
                  style: textTheme.bodyMedium,
                ),
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Opción: Enlace (próx.)
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: RadioListTile<int>(
                value: 2,
                groupValue: _selectedFormat,
                title: Text(
                  'Enlace (próx.)',
                  style: textTheme.bodyMedium,
                ),
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // ======= Incluir: Preguntas / Respuestas =======
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Incluir:',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox: Preguntas
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: CheckboxListTile(
                title: Text(
                  'Preguntas',
                  style: textTheme.bodyMedium,
                ),
                value: _includePreguntas,
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _includePreguntas = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox: Respuestas
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: CheckboxListTile(
                title: Text(
                  'Respuestas',
                  style: textTheme.bodyMedium,
                ),
                value: _includeRespuestas,
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _includeRespuestas = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),

            const SizedBox(height: 24),

            // ======= Vista previa de la conversación =======
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: colorScheme.outline.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '[Vista previa de la conversación]',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurface.withOpacity(0.45)),
              ),
            ),

            const SizedBox(height: 32),

            // ======= Botón COMPARTIR =======
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para compartir, por ejemplo:
                  // - Si _selectedFormat == 1 y _includePreguntas == true, etc.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Se ha compartido la conversación.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      colorScheme.primary, // Using primary color from theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'COMPARTIR',
                  style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary, letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
