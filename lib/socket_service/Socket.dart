import 'dart:io';
import 'dart:typed_data';

import 'package:acessibility_project/socket_service/WifiController.dart';

class SocketController {
  Future<void> createScocket() async {
    WifiController wifiController = new WifiController();
    String ip = await wifiController.getIp();
    final server = await ServerSocket.bind(ip, 3003);
    print(ip);
    server.listen((client) {
      handleConnection(client);
    });
  }

  Future<Socket> connectToSocket() async {
    WifiController wifiController = new WifiController();
    String ip = "192.168.0.11";
    final socket = await Socket.connect(ip, 3003);
    print(socket != null ? "Socket connected" : "Error on settingup socket");
    socket.write("qualquer mensagem");
    return socket;
  }

  handleConnection(Socket socket) {
    socket.listen(
      (Uint8List data) async {
        await Future.delayed(Duration(seconds: 1));
        socket.write("Teste comunicação");
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
    print("ListConnection");
    socket.listen((Uint8List data) {
      print("ListConnection2");
      final serverResponse = String.fromCharCodes(data);
      print("Server: $serverResponse");
    });
  }
}
