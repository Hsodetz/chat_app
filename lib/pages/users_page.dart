
import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final userService = UsersService();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> usuarios = [];

  // final usuarios = [
  //   User(uid: '1', nombre: 'María', email: 'test1@test.com', online: true ),
  //   User(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false ),
  //   User(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true ),
  // ];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
       appBar: AppBar(
        title: Text(authService.usuario?.nombre.toString() ?? 'Usuario', style: const TextStyle(color: Colors.black87 ) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            socketService.disconnect();
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: socketService.serverStatus == ServerStatus.Online ? Icon( Icons.check_circle, color: Colors.blue[400] ) : const Icon( Icons.offline_bolt, color: Colors.red ),
            // child: Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue.shade400,
        ),
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile( usuarios[i] ), 
      separatorBuilder: (_, i) => const Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile( User usuario ) {
    return ListTile(
        title: Text( usuario.nombre ),
        subtitle: Text( usuario.email ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( usuario.nombre .substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          print(usuario.nombre);
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.userTo = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _cargarUsuarios() async {

    usuarios = await userService.getUsers();
    setState(() {});

    //await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
}




