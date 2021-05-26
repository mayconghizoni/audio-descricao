import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:acessibility_project/socket_service/WifiController.dart';
import 'package:sound_stream/sound_stream.dart';

class SocketController {
  static RecorderStream _recorder = RecorderStream();
  static PlayerStream _player = PlayerStream();
  static WifiController wifiController = new WifiController();
  ServerSocket server;

  Future<void> createScocket() async {
    String ip = await wifiController.getIp();
    server = await ServerSocket.bind(ip, 3003);

    server.listen((client) {
      handleConnection(client);
    });
  }

  Future<Socket> connectToSocket() async {
    String ip = "192.168.0.100";
    final socket = await Socket.connect(ip, 3003);

    print(socket != null ? "Socket connected" : "Error on settingup socket");
    socket.write("mensagem enviada pelo cliente");

    return socket;
  }

  handleConnection(Socket socket) {
    _recorder.initialize();
    _recorder.start();

    _player.initialize();
    _player.start();
    bool _isPlaying = true;

    socket.listen(
      (Uint8List data) async {
        _recorder.audioStream.listen((data) {
          if (_isPlaying) {
            _player.audioStream.add(data);
            socket.add(data);
          }
        });
      },
      onError: (error) {
        print(error);
        socket.close();
      },
      onDone: () {
        print("Client left");
        socket.close();
      },
    );
  }

  listenConnection(Socket socket) async {
    _player.initialize();
    _player.start();

    socket.listen((Uint8List data) {
      _player.audioStream.add(data);
    });
  }
}
