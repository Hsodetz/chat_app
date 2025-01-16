import 'dart:math';

import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      
      // Conectar al socket server
      socketService.connect();
      
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const UsersPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut
          )),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 1000)
      ));
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }




  }
}