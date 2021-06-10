import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:acessibility_project/ui/listener/home_receptor.dart';
import 'package:flutter/material.dart';
import 'package:acessibility_project/ui/storyteller/home.dart';

class Decision extends StatefulWidget {
  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  showHomeStoryteller() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Home(),
        ));
  }

  showHomeListener() async {

  SocketController socketController = new SocketController();
  List<String> rooms = (await socketController.listConnecions()).first;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeReceptor(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: showHomeListener,
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
