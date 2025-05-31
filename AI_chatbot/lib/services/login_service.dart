import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LoginService {
  static const String _assetPath = 'assets/jsons/users.json';

  Future<File> _getUsersFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<String> _loadUsersData() async {
    final file = await _getUsersFile();

    if (await file.exists()) {
      // Si existe el archivo actualizado, usarlo
      return await file.readAsString();
    } else {
      // Si no existe, usar el original de assets
      return await rootBundle.loadString(_assetPath);
    }
  }

  Future<bool> validateUser(String email, String password) async {
    try {
      final String data = await _loadUsersData();
      final json = jsonDecode(data)['usuarios'] as List;

      print("JSON cargado: $json"); // Debug 1
      print("Buscando: email=$email, password=$password"); // Debug 2

      for (var user in json) {
        print(
            "Usuario en JSON: ${user['email']} - ${user['password_hash']}"); // Debug 3
        if (user['email'] == email && user['password_hash'] == password) {
          print("¡Usuario encontrado!"); // Debug 4
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error en validateUser: $e");
      return false;
    }
  }
}
