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

  Future<List<String>> listConnecions() async {
    List<String> rooms = new List<String>();
    String ip = await wifiController.getIp();
    ip = ip.substring(0, ip.lastIndexOf(".") + 1);
    String port = "3003";

    for (int i = 1; i < 255; i++) {
      String tempIP = ip + i.toString();
      try {
        final socket = await Socket.connect(tempIP, 3003,
            timeout: new Duration(milliseconds: 200));
        if (socket != null) {
          rooms.add(tempIP);
          socket.close();
        }
      } catch (Exception) {
        continue;
      }
    }
    print(rooms);
    return rooms;
  }

  Future<Socket> connectToSocket() async {
    String ip = await wifiController.getIp();
    var initTime = DateTime.now().millisecondsSinceEpoch;
    final socket = await Socket.connect(ip, 3003);
    print("Connected in " +
        (DateTime.now().millisecondsSinceEpoch - initTime).toString());
    print(socket != null ? "Socket connected" : "Error on settingup socket");
    socket.write("mensagem enviada pelo cliente");

    return socket;
  }

  handleConnection(Socket socket) 
  {
    _recorder.initialize();
    _recorder.start();

    _player.initialize();
    _player.start();
    bool _isPlaying = true;

    socket.listen(
      (Uint8List data) async {
        _recorder.audioStream.listen((data) {
          if (_isPlaying) {
            socket.add(data);
          }
        });
      },
      onError: (error) {
        print(error);
        socket.close();
        socket.destroy();
      },
      onDone: () {
        print("Client left");
        socket.close();
        socket.destroy();
      },
    );
  }

  listenConnection(Socket socket) async {
    _player.initialize();
    _player.start();

    socket.listen(
        (Uint8List data) {
        _player.audioStream.add(data);
      },
      onError: ()
      {
        socket.close();
        socket.destroy();
      },
      onDone: ()
      {
        socket.close();
        socket.destroy();
      }
    );
  }

  closeConnections(ServerSocket server)
  {
    server.close();
    server.drain();
  }
}
