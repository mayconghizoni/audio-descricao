class GlobalUtils
{

  static String appName = "Áudio Descrição";

  static String getAppName()
  {
    return appName;
  }

  int getActualTime()
  {
    return DateTime.now().millisecondsSinceEpoch;
  } 

}