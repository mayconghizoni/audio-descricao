import 'package:acessibility_project/socket_service/WifiController.dart';

class GlobalUtils
{

  static String appName = "Áudio Descrição";
  static String roomName = "";

  static String getAppName()
  {
    return appName;
  }

  int getActualTime()
  {
    return DateTime.now().millisecondsSinceEpoch;
  } 

  static void setRoomName(String room){roomName = room;}

  static String getRoomName(){return roomName;}

  static Future<String> getMyIp() async{return await WifiController().getIp();}

}