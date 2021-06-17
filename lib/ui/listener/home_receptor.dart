import 'dart:io';
import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:acessibility_project/ui/listener/transmition_receptor.dart';
import 'package:flutter/material.dart';

class HomeReceptor extends StatefulWidget {
  final List objects;
  HomeReceptor(this.objects);
  @override
  _HomeReceptorState createState() => _HomeReceptorState(this.objects);
}

class _HomeReceptorState extends State<HomeReceptor> {
  List objects;
  _HomeReceptorState(this.objects);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Central do ouvinte"),
        backgroundColor: Colors.deepOrangeAccent,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: buildListView(),
    );
  }

  ListView buildListView() {
    List<String> rooms = objects.first;
    List<String> ips = objects.last;
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        var listTile = ListTile(
            title: Text(
              '${rooms[index]}',
              style: TextStyle(fontSize: 25.0),
            ),
            leading: Icon(Icons.meeting_room),
            onTap: () => connectToSocket('${ips[index]}'),
          );
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: listTile,
        );
      },
    );
  }

  connectToSocket(String ip) async{
    showSnackBar();
    SocketController sc = new SocketController();
    Socket socket = await sc.connectToSocket(ip);
    sc.listenConnection(socket);

        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new TransmitionReceptor(),
        ));
  }

    showSnackBar() async {

    final snackBar = SnackBar(content: Row(
      children: [
        Icon(Icons.add),
        SizedBox(width: 10,),
        Expanded(child: Text("Conectando à salas...")),
      ],
    ),
    duration: Duration(seconds: 20),);
        // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
