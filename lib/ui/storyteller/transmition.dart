import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';

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
        backgroundColor: Colors.deepOrange,
        // actions: <Widget>[],
      ),
      backgroundColor: Colors.lightBlueAccent[100],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // IconButton(
                //   iconSize: 96.0,
                //   icon: Icon(_isRecording ? Icons.mic : Icons.mic_off),
                //   // onPressed: _isRecording ? _recorder.stop : _recorder.start,
                // ),
                // IconButton(
                //   iconSize: 96.0,
                //   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                //   //onPressed: _isPlaying ? _player.stop : _play,
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: closeSocket,
                child: Text(
                  "Finalizar Transmissão",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
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

  closeSocket() {}
}
