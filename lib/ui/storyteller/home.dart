import 'dart:async';
import 'dart:io';

import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:acessibility_project/ui/storyteller/transmition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _salaController = new TextEditingController();
  showMessage() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Nome da sala: "),
              content: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _salaController,
                      decoration: InputDecoration(
                        hintText: "Teatro da Liga",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("YES"),
                  onPressed: initTransmition,
                  isDefaultAction: true,
                ),
                CupertinoDialogAction(
                  child: Text("NO"),
                  onPressed: cancel,
                  isDestructiveAction: true,
                )
              ],
            ),
        barrierDismissible: true);
  }

  initTransmition() {
    Future.delayed(Duration(seconds: 5), () => nextPage());
    Navigator.of(context).pop(false);
    final snackBar = SnackBar(
        content: Text("Iniciando transmissão de " + _salaController.text));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  cancel() {
    Navigator.of(context).pop(false);
  }

  nextPage() async {
    print("nextPage");
    SocketController socketController = new SocketController();
    await socketController.createScocket();

    Future.delayed(Duration(seconds: 10));

    Socket socket = await socketController.connectToSocket();
    socketController.listenConnection(socket);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Transmition(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            Text("Inicie sua transmissão!",
                style: TextStyle(
                    fontSize: 25.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrangeAccent))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: Icon(Icons.settings),
              // ignore: deprecated_member_use
              title: Text("Settings")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showMessage,
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
