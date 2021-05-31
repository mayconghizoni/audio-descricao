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
        title: Text("Áudio Descrição"),
        backgroundColor: Colors.deepOrange,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.lightBlueAccent[100],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nome da sala",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrangeAccent,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: connectToSocket,
                child: Text(
                  "ENTRAR",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                color: Colors.deepOrangeAccent,
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
