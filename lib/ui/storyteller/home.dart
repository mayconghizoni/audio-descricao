import 'dart:async';
import 'dart:io';

import 'package:acessibility_project/GlobalUtils.dart';
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
    String roomName = _salaController.text;
    GlobalUtils.setRoomName(roomName);
    SocketController socketController = new SocketController();
    await socketController.createScocket();
    //Socket socket = await socketController.connectToSocket();
    //socketController.listenConnection(socket);
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
        title: Text("Central de Transmissão"),
        backgroundColor: Colors.deepOrangeAccent,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
              child: Text("Ao iniciar sua transmissão:",
                  style: TextStyle(
                      fontSize: 20.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.deepOrangeAccent)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                "- Se conecte a rede local de transmissão;",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                "- Tenha conectado ao aparelho fones de ouvido;",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                "- Encerre outros apps para melhor desempenho;",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                "- Assim que iniciar iniciar seu microfone será ativo;",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.deepOrangeAccent),
              ),
            )
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
