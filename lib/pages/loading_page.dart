import 'dart:math';

import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(child: SizedBox(
            width: 100,
            height: 100,
            child: Column(
              children: [
                
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Cargando...'),
              ],
            ),
          ));
        },
      ),
   );
  }

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      Navigator.pushReplacementNamed(context, 'users');  
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }




  }
}