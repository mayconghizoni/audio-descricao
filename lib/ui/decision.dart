import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:acessibility_project/ui/listener/home_receptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acessibility_project/ui/storyteller/home.dart';

class Decision extends StatefulWidget {
  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isEnabled = true;

  showHomeStoryteller() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Home(),
        ));
  }

  disableButton() {
    setState(() {
      isEnabled = false;
      showHomeListener();
    });
  }

  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  showHomeListener() async {
    showSnackBar();
    SocketController socketController = new SocketController();
    List objects = await socketController.listConnecions();
    List validation = objects[0];

    if (validation.isNotEmpty) {
      _scaffoldKey.currentState!.hideCurrentSnackBar();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new HomeReceptor(objects),
          ));
    } else {
      nullListlert();
      enableButton();
    }
  }

  nullListlert() {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Ops! Nenhuma sala encontrada"),
              content: Card(
                color: Colors.transparent,
                elevation: 0.0,
              ),
            ),
        barrierDismissible: true);
  }

  showSnackBar() async {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.search),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text("Procurando salas...")),
        ],
      ),
      duration: Duration(seconds: 90),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Áudio Descrição"),
        backgroundColor: Colors.deepOrangeAccent,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: isEnabled ? () => disableButton() : null,
                color: Colors.deepOrangeAccent,
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "Ouvinte",
                  style: TextStyle(
                    fontSize: 45.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: showHomeStoryteller,
                color: Colors.deepOrangeAccent,
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "Narrador",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
