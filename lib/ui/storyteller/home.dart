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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _name = "";

  validateInputNameCall() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      initTransmition();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  showMessage() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Nome da sala: "),
              content: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _salaController,
                    decoration: InputDecoration(
                      hintText: "Teatro da Liga",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String arg) {
                      if (arg.length < 3)
                        return 'Digite o nome da sala';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _name = val;
                    },
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("YES"),
                  onPressed: validateInputNameCall,
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
    String textToSend = _salaController.text;
    SocketController socketController = new SocketController();
    await socketController.createScocket();
    Socket socket = await socketController.connectToSocket();
    socketController.listenConnection(socket);
    ServerSocket server = socketController.getServer();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Transmition(textToSend, server),
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
