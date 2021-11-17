import 'package:acessibility_project/GlobalUtils.dart';
import 'package:acessibility_project/socket_service/Socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Transmition extends StatefulWidget {
  @override
  Transmition();
  _TransmitionState createState() => _TransmitionState();
}

class _TransmitionState extends State<Transmition> {
  _TransmitionState();

  @override
  Widget build(BuildContext context) {
    bool _isRecording = false;
    bool _isPlaying = false;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  iconSize: 96.0,
                  icon: Icon(_isRecording ? Icons.mic : Icons.mic_off),
                  onPressed: () => {},
                  // onPressed: _isRecording ? _recorder.stop : _recorder.start,
                ),
                IconButton(
                  iconSize: 96.0,
                  icon: Icon(_isPlaying ? Icons.headset : Icons.headset_off),
                  onPressed: () => {},
                  //onPressed: _isPlaying ? _player.stop : _play,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.deepOrangeAccent,
                padding: const EdgeInsets.all(25.0),
                onPressed: () => closeSocket(),
                child: Text(
                  "Finalizar Transmissão",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
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

  closeSocket() async {
    SocketController socketController = new SocketController();
    print("Fechando o servidor");
    GlobalUtils utils = new GlobalUtils();
    //Retorna o objeto Socket e escreve uma mensagem nesse socket.
    (await socketController.connectToSocket(await utils.getMyIp()))!.write("Close Server");
    Phoenix.rebirth(context);
  }
}
