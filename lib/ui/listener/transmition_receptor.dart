import 'package:flutter/material.dart';

class TransmitionReceptor extends StatefulWidget {
  @override
  _TransmitionReceptor createState() => _TransmitionReceptor();
}

class _TransmitionReceptor extends State<TransmitionReceptor> {
  bool _isRecording = false;
  bool _isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Transmissão ativa"),
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
                  "Sair",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
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
