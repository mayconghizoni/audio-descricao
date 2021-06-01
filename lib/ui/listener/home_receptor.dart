import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:flutter/material.dart';

class HomeReceptor extends StatefulWidget {
  @override
  _HomeReceptorState createState() => _HomeReceptorState();
}

class _HomeReceptorState extends State<HomeReceptor> {
  // ignore: deprecated_member_use
  List<String> rooms = new List<String>();

  @override
  void initState() {
    SocketController socketController = new SocketController();
    // rooms = socketController.listConnections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Central do ouvinte"),
        backgroundColor: Colors.deepOrangeAccent,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Continuar
          ],
        ),
      ),
    );
  }

  // connectToSocket() async {
  //   SocketController socketController = new SocketController();
  //   Socket socket = await socketController.connectToSocket();
  //   socketController.listenConnection(socket);
  // }
}
