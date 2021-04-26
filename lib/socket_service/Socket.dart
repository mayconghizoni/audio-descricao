import 'dart:io';

import 'package:acessibility_project/socket_service/WifiController.dart';

class SocketController{

  void createScocket() async
  {
    WifiController wifiController = new WifiController();
    String ip = await wifiController.getIp();
    final socket = ServerSocket.bind(ip, 3003);
    print(ip);
  }

  void connectToSocket() async
  {
    WifiController wifiController = new WifiController();
    String ip = await wifiController.getIp();
    final socket = await Socket.connect(ip, 3003);
  }


}