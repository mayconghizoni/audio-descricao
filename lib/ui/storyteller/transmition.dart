import 'package:flutter/material.dart';

class Transmition extends StatefulWidget {
  @override
  final String text;
  Transmition(this.text);
  _TransmitionState createState() => _TransmitionState(this.text);
}

class _TransmitionState extends State<Transmition> {
  String text;
  _TransmitionState(this.text);

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
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
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
                onPressed: () => {},
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
}
