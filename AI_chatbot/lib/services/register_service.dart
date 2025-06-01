// lib/services/register_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class RegisterService {
  /// Firma: recibe email, nombre y password, y devuelve true/false
  Future<bool> registerUser({
    required String email,
    required String nombre,
    required String password,
  }) async {
    // 1) Cargo el JSON completo de usuarios
    final jsonData = await rootBundle.loadString('assets/jsons/users.json');
    final Map<String, dynamic> dataMap = json.decode(jsonData);

    // 2) Compruebo si ya hay un usuario con ese email
    final List usuariosJson = dataMap['usuarios'] as List;
    final bool existe = usuariosJson.any((u) => u['email'] == email);
    if (existe) {
      // Si ya existe el email, retorno false: fallo en el registro
      return false;
    }

    // 3) Si no existe, creo mi nuevo objeto Usuario
    //    Asigno la misma imagen por defecto para todos los nuevos:
    const defaultImageUrl =
        'https://images.seeklogo.com/logo-png/28/1/psyduck-logo-png_seeklogo-286537.png';

    final nuevoUsuario = Usuario(
      usuario_id: usuariosJson.length + 1,
      email: email,
      password_hash: password,
      nombre: nombre,
      fecha_registro: DateTime.now().toUtc(),
      ultimo_acceso: null,
      imagen_url: defaultImageUrl, // ← aquí ponemos el URL por defecto
    );

    // 4) Agrego el nuevo usuario al arreglo del JSON en memoria
    usuariosJson.add(nuevoUsuario.toJson());

    // 5) En un entorno real, aquí reescribirías el archivo JSON
    //    o harías un insert a la base de datos. Pero como esto es solo “mock”,
    //    limitamos la simulación y devolvemos true para indicar éxito.
    return true;
  }
}
