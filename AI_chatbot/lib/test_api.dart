// lib/test_api.dart

import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({Key? key}) : super(key: key);

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Establecer credenciales de prueba por defecto
    _emailController.text = 'usuario1@example.com';
    _passwordController.text = 'password123';
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _result = '''
🔄 PROBANDO CONEXIÓN...
Backend: http://localhost:3001
Endpoint: /api/auth/login
Email: ${_emailController.text}
Password: ${_passwordController.text}

Esperando respuesta...
''';
    });

    try {
      final response = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        if (response.success) {
          _result = '''
✅ LOGIN EXITOSO!
Mensaje: ${response.message}
Usuario: ${response.data?.nombre}
Email: ${response.data?.email}
ID: ${response.data?.usuario_id}
Fecha Registro: ${response.data?.fecha_registro}

🎉 ¡La integración frontend-backend funciona correctamente!
''';
        } else {
          _result = '''
❌ LOGIN FALLIDO
Error: ${response.message}

Posibles causas:
• Email o password incorrectos
• Backend no está ejecutándose
• Credenciales no están en la base de datos
''';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = '''
🔥 EXCEPCIÓN DE CONEXIÓN
Error: $e

Verificar:
• ¿Está el backend ejecutándose en puerto 3001?
• ¿Tienes conexión a internet/localhost?
• ¿Los passwords fueron hasheados correctamente?

Comando para verificar backend:
curl http://localhost:3001/api/auth/login
''';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Prueba de Autenticación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Probar Login',
                            style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _emailController.text = 'user3@test.com';
                      _passwordController.text = 'password123';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Usar user3@test.com',
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _result = '''
🔧 INFORMACIÓN DE DEBUG

Backend URL: http://localhost:3001
API Base: http://localhost:3001/api
Login Endpoint: /api/auth/login

Credenciales disponibles:
• usuario1@example.com / password123
• user3@test.com / password123  
• user4@test.com / password123

Estado del backend:
${DateTime.now().toString()}

Para verificar manualmente:
curl -X POST http://localhost:3001/api/auth/login \\
  -H "Content-Type: application/json" \\
  -d "{\\"email\\":\\"user3@test.com\\",\\"password\\":\\"password123\\"}"
''';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Mostrar Info Debug'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result.isEmpty
                        ? 'Haz clic en "Probar Login" para comenzar'
                        : _result,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Credenciales de prueba disponibles:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• usuario1@example.com / password123'),
            const Text('• user3@test.com / password123'),
            const Text('• user4@test.com / password123'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
