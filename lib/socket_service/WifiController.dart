import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WifiController
{
  Future<String> getIp() async
  {
    return WifiInfo().getWifiIP();
  }
}