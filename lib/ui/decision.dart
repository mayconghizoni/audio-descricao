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

  showHomeListener() {
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
              padding: const EdgeInsets.all(25.0),
              child: Text("Inicie sua transmissão!",
                  style: TextStyle(
                      fontSize: 25.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepOrangeAccent)),
            ),
            // ignore: deprecated_member_use
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                onPressed: showHomeListener,
                color: Colors.deepOrange,
                child: Text(
                  "Ouvinte",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ignore: deprecated_member_use
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                onPressed: showHomeStoryteller,
                color: Colors.deepOrange,
                child: Text(
                  "Narrador",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
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
