import 'package:flutter/material.dart';

class HomeReceptor extends StatefulWidget {
  final List<String> rooms;
  HomeReceptor(this.rooms);
  @override
  _HomeReceptorState createState() => _HomeReceptorState(this.rooms);
}

class _HomeReceptorState extends State<HomeReceptor> {
  List<String> rooms;
  _HomeReceptorState(this.rooms);

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
          children: rooms.map((quote) {
            return Text(quote);
          }).toList(),
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
