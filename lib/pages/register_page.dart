import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                const Logo( titulo: 'Registro' ),

                _Form(),

                const Labels( 
                  ruta: 'login',
                  titulo: '¿Ya tienes una cuenta?',
                  subTitulo: 'Ingresa ahora!',
                ),

                const Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ),)

              ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
       child: Column(
         children: <Widget>[
           
           CustomInput(
             icon: Icons.perm_identity,
             placeholder: 'Nombre',
             keyboardType: TextInputType.text, 
             textController: nameCtrl,
           ),

           CustomInput(
             icon: Icons.mail_outline,
             placeholder: 'Correo',
             keyboardType: TextInputType.emailAddress, 
             textController: emailCtrl,
           ),

           CustomInput(
             icon: Icons.lock_outline,
             placeholder: 'Contraseña',
             textController: passCtrl,
             isPassword: true,
           ),
           

           BotonAzul(
             text: 'Crear cuenta',
           
              onPressed: authService.autenticando ? () => {} : () async {
                print( emailCtrl.text );
                print( passCtrl.text );
                print(authService.autenticando);

                FocusScope.of(context).unfocus();
                
                final registerOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());

                if ( registerOk == true ) { 
                  Navigator.pushReplacementNamed(context, 'users'); 
                } else {
                  mostrarAlerta(context, 'Credenciales Repetidas', 'Email ya registrado, por favor intente con otro email');
                }
             },
           )



         ],
       ),
    );
  }
}