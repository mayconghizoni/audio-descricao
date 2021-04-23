import 'package:flutter/material.dart';

class Transmition extends StatefulWidget {
  @override
  _TransmitionState createState() => _TransmitionState();
}

class _TransmitionState extends State<Transmition> {
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
            Text(
              "Nome da sala ",
              style: TextStyle(
                fontSize: 24.5,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
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
    );
  }
}
