import 'package:acessibility_project/ui/transmition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final snackBar = SnackBar(content: Text("Iniciando Transmissão..."));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  cancel() {
    Navigator.of(context).pop(false);
  }

  nextPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Transmition()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Olho por olho... Não, pera!"),
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
              "Bem vindo ao Acessibility!",
              style: TextStyle(
                fontSize: 24.5,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
            Text("Inicie sua transmissão!",
                style: TextStyle(
                    fontSize: 20.5,
                    fontWeight: FontWeight.w400,
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
