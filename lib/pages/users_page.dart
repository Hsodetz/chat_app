
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    User(uid: '1', nombre: 'María', email: 'test1@test.com', online: true ),
    User(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false ),
    User(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Mi Nombre', style: TextStyle(color: Colors.black87 ) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue[400] ),
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
          child: Text( usuario.nombre .substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  _cargarUsuarios() async { 

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
}




