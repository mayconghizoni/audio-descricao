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
      body: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            title: Text(
              '${rooms[index]}',
              style: TextStyle(fontSize: 25.0),
            ),
            leading: Icon(Icons.meeting_room),
            onTap: () => {},
          ),
        );
      },
    );
  }
}
