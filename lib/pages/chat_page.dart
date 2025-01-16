import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];
  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService?.socket?.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService!.userTo!.uid);
  }

  void _cargarHistorial(String userId) async {
    List<Message> chat = await chatService!.getChat(userId);
    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 0 ))..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });


  }

  void _escucharMensaje( dynamic payload ) {
    print('Tengo mensaje $payload');

    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 400 )),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  } 

  @override
  Widget build(BuildContext context) {
    
    final userTo = chatService?.userTo;

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(userTo?.nombre.substring(0,2) ?? '', style: const TextStyle(fontSize: 12) ),
            ),
            const SizedBox( height: 3 ),
            Text(userTo?.nombre ?? '', style: const TextStyle( color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )
          ),

          const Divider( height: 1 ),

          // TODO: Caja de texto
          Container(
            color: Colors.white,
            height: 70,
            child: _inputChat(),
          )
        ],
      ),
   );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 10.0 ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit ,
                onChanged: ( texto ){
                  setState(() {
                    texto.trim().isNotEmpty ? _estaEscribiendo = true : _estaEscribiendo = false;
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            // Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
              child: Platform.isIOS 
              ? CupertinoButton(
                onPressed: _estaEscribiendo ? () => _handleSubmit( _textController.text.trim() ): null,
                padding: const EdgeInsets.all(0.9),
                child: const Text('Enviar', style: TextStyle(color: Colors.red),),
              )
              
              : Container(
                margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400] ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon( Icons.send ),
                    onPressed: _estaEscribiendo 
                      ? () => _handleSubmit( _textController.text.trim() )
                      : null,
                  ),
                ),
              ),
            )

          ],
        ),
      )
    );

  }


  _handleSubmit(String texto ) {

    if ( texto.isEmpty ) return;

    //print( texto );

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService!.usuario!.uid,
      texto: texto,
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 400 )),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    socketService?.emit!('mensaje-personal', {
      'de': authService?.usuario?.uid,
      'para': chatService?.userTo?.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {

    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }

    // para desconectarme y no seguir escuchando mensajes
    socketService?.socket?.off('mensaje-personal');

    super.dispose();
  }
}