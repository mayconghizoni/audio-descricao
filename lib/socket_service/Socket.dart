import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:acessibility_project/GlobalUtils.dart';
import 'package:acessibility_project/socket_service/WifiController.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SocketController {
  static RecorderStream _recorder = RecorderStream();
  static PlayerStream _player = PlayerStream();
  static WifiController wifiController = new WifiController();
  static ServerSocket server;
  static Socket socket;
  static List<String> roomsNames = new List();
  static bool isServerClosed = false;

  Future<void> createScocket() async {
    String ip = await wifiController.getIp();
    server = await ServerSocket.bind(ip, 3003);

    server.listen((client) {
      handleConnection(client);
    });
  }

  Future<List> listConnecions() async {
    List objects = new List();
    List<String> ips = new List<String>();
    String ip = await wifiController.getIp();
    ip = ip.substring(0, ip.lastIndexOf(".") + 1);

    for (int i = 50; i < 120; i++) {
      String tempIP = ip + i.toString();
      try {
        final socket = await Socket.connect(tempIP, 3003,
            timeout: new Duration(milliseconds: 350));
        if (socket != null) {
          socket.write("Testing connection");
          listenRoomsNames(socket);
          ips.add(tempIP);
          socket.close();
        }
      } catch (Exception) {
        continue;
      }
    }
    objects.add(SocketController.roomsNames);
    objects.add(ips);
    return objects;
  }

  listenRoomsNames(Socket socket) async {
    socket.listen((Uint8List data) {
      SocketController.roomsNames.add(String.fromCharCodes(data));
    }, onError: (error) {
      socket.close();
      socket.destroy();
    }, onDone: () {
      socket.close();
      socket.destroy();
    });
  }

  Future<Socket> connectToSocket(String ip) async {
    var initTime = DateTime.now().millisecondsSinceEpoch;
    socket = await Socket.connect(ip, 3003);

    print("Connected in " +
        (DateTime.now().millisecondsSinceEpoch - initTime).toString());
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
        if (String.fromCharCodes(data) == "Testing connection") {
          socket.write(GlobalUtils.getRoomName());
        } else if (String.fromCharCodes(data) ==
            "mensagem enviada pelo clienteClose Server") {
          await closeAllConnections();
        } else {
          _recorder.audioStream.listen((data) {
            if (isServerClosed) {
              socket.write("Sai fora");
            } else {
              if (_isPlaying) {
                socket.add(data);
              }
            }
          });
        }
      },
      onError: (error) {
        print(error);
        socket.close();
        socket.destroy();
      },
      onDone: () async {
        print("Client left");
        socket.close();
        socket.destroy();
      },
    );
  }

  listenConnection(Socket socket) async {
    _player.initialize();
    _player.start();

    socket.listen((Uint8List data) {
      if (String.fromCharCodes(data).contains("teste")) {
        GlobalUtils.setRoomName(String.fromCharCodes(data));
      } else if (String.fromCharCodes(data).contains("fora")) {
        socket.destroy();
      } else {
        _player.audioStream.add(data);
      }
    }, onError: (error) {
      socket.close();
      socket.destroy();
    }, onDone: () {
      socket.close();
      socket.destroy();
    });
  }

  static void closeAllConnections() async {
    isServerClosed = true;
    await server.close();
    await socket.destroy();
  }

  static void closeClientSocket(context) {
    socket.destroy();
    Phoenix.rebirth(context);
  }
}
