import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RegisterService {
  static const String _assetPath = 'assets/jsons/users.json';

  Future<File> _getUsersFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<void> _initializeUsersFile() async {
    final file = await _getUsersFile();
    if (!await file.exists()) {
      // Si no existe, copiamos desde assets
      final String jsonString = await rootBundle.loadString(_assetPath);
      await file.writeAsString(jsonString);
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      // 1. Inicializar archivo si no existe
      await _initializeUsersFile();

      // 2. Cargar usuarios existentes
      final file = await _getUsersFile();
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // 3. Verificar si el email ya existe
      final List usuarios = data['usuarios'];
      for (var user in usuarios) {
        if (user['email'] == email) {
          throw Exception('El email ya está registrado');
        }
      }

      // 4. Crear nuevo usuario
      final newUser = {
        "usuario_id": DateTime.now().millisecondsSinceEpoch,
        "email": email,
        "password_hash": password,
        "nombre": name,
        "fecha_registro": DateTime.now().toIso8601String().split('T')[0],
        "ultimo_acceso": null
      };

      // 5. Agregar el nuevo usuario
      data['usuarios'].add(newUser);

      // 6. Sobreescribir el archivo
      await file.writeAsString(jsonEncode(data));
      final directory = await getApplicationDocumentsDirectory();
      print("Directorio de documentos: ${directory.path}");

      print('Usuario registrado con éxito: $newUser');
    } catch (e) {
      print('Error al registrar: $e');
      final directory = await getApplicationDocumentsDirectory();
      print("Directorio de documentos: ${directory.path}");

      throw Exception('Error al guardar los datos: ${e.toString()}');
    }
  }
}
