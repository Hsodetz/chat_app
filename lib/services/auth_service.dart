import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? usuario;
  bool _autenticando = false;
  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }



  Future<bool> login(String email, String password) async {
    autenticando = true;

    print('autenticando');

    print(autenticando);
    
    final data = {
      'email': email,
      'password': password
    };
    print('ovejita');
    print(data);
    print(jsonEncode(data));

    final uri = Uri.parse('${ Environment.apiUrl }/login');
    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );


    print(resp.body);
    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }

  }

   Future<bool> register(String name, String email, String password) async {
    print('registrando');
    autenticando = true;
    
    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Environment.apiUrl }/new');
    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );


    print(resp.body);
    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final registerResponse = loginResponseFromJson( resp.body );
      usuario = registerResponse.usuario;
      await saveToken(registerResponse.token);
      return true;
    } else {
      return false;
    }

  }

  // Validamos si el token que esta en el storage es valido comparandolo contra el backend
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    print(token);
    final uri = Uri.parse('${ Environment.apiUrl }/renew');

    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );

    print(resp.body);
  
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await saveToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future saveToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() {
    // Delete value
    return _storage.delete(key: 'token'); 
  }
  
  
}