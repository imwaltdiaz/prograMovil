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
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF5F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Compartir conversación',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
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
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Opción: Texto plano
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                title: const Text(
                  'Texto plano',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                activeColor: Colors.blueAccent,
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
                color: Colors.white,
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
                title: const Text(
                  'Imagen',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                activeColor: Colors.blueAccent,
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
                color: Colors.white,
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
                title: const Text(
                  'Enlace (próx.)',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                activeColor: Colors.blueAccent,
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
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox: Preguntas
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                title: const Text(
                  'Preguntas',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                value: _includePreguntas,
                activeColor: Colors.blueAccent,
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
                color: Colors.white,
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
                title: const Text(
                  'Respuestas',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                value: _includeRespuestas,
                activeColor: Colors.blueAccent,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '[Vista previa de la conversación]',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Colors.black45,
                ),
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
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'COMPARTIR',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
