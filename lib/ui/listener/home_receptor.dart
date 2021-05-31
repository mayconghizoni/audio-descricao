import 'dart:io';

import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:flutter/material.dart';

class HomeReceptor extends StatefulWidget {
  @override
  _HomeReceptorState createState() => _HomeReceptorState();
}

class _HomeReceptorState extends State<HomeReceptor> {
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
            // ignore: deprecated_member_use
            RaisedButton(
              padding: const EdgeInsets.all(25.0),
              color: Colors.deepOrangeAccent,
              onPressed: connectToSocket,
              child: Text(
                "Conectar-se",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  connectToSocket() async {
    SocketController socketController = new SocketController();
    Socket socket = await socketController.connectToSocket();

    socketController.listenConnection(socket);
  }
}
