import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:acessibility_project/GlobalUtils.dart';
import 'package:acessibility_project/socket_service/WifiController.dart';
import 'package:acessibility_project/sound_service/SoundController.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

const int tSampleRate = 16000;

class SocketController 
{

  SoundController soundController = SoundController();
  static WifiController wifiController = new WifiController();

  static ServerSocket? server;
  static Socket? socket;

  static List<String> roomsNames = new List.empty();
  static bool isServerClosed = false;

  StreamSubscription? _mRecordingDataSubscription;
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();

  var recordingDataController = StreamController<Food>();
  
  static bool recorderStarted = false;
  static bool playerStarted = false;
  

  Future<void> enableRecorder() async
  {
    _recorder = await soundController.getSoundRecorder();
  }
  Future<void> enablePlayer() async
  {
    _player = await soundController.getSoundPlayer();
  }

  Future<void> createScocket() async 
  {
    String? ip = await wifiController.getIp();
    server = await ServerSocket.bind(ip, 3003);

    await enableRecorder();

    server?.listen((client) {
      handleConnection(client);
    });
  }

  Future<List> listConnecions() async 
  {
    List objects = new List.empty();
    List<String> ips = new List.empty();
    String? ip = await wifiController.getIp();
    ip = ip?.substring(0, ip.lastIndexOf(".") + 1);

    for (int i = 50; i < 120; i++) 
    {
      String tempIP = ip! + i.toString();
      try 
      {
        final socket = await Socket.connect(tempIP, 3003,
            timeout: new Duration(milliseconds: 350));
        if (socket != null) 
        {
          socket.write("Testing connection");
          listenRoomsNames(socket);
          ips.add(tempIP);
          socket.close();
        }
      } 
      catch (Exception) 
      {
        continue;
      }
    }
    objects.add(SocketController.roomsNames);
    objects.add(ips);
    return objects;
  }

  listenRoomsNames(Socket socket) async 
  {
    socket.listen((Uint8List data) 
    {
      SocketController.roomsNames.add(String.fromCharCodes(data));
    }, 
    onError: (error) 
    {
      socket.close();
      socket.destroy();
    }, 
    onDone: () 
    {
      socket.close();
      socket.destroy();
    });
  }

  Future<Socket?> connectToSocket(String? ip) async {
    var initTime = DateTime.now().millisecondsSinceEpoch;
    socket = await Socket.connect(ip, 3003);

    print("Connected in " +
        (DateTime.now().millisecondsSinceEpoch - initTime).toString());
    print(socket != null ? "Socket connected" : "Error on settingup socket");
    socket?.write("mensagem enviada pelo cliente");

    await enablePlayer();

    return socket;
  }

  handleConnection(Socket socket) async
  {
    socket.listen(
      (Uint8List data) async 
      {
        if (String.fromCharCodes(data) == "Testing connection") 
        {
          socket.write(GlobalUtils.getRoomName());
        } 
        else if (String.fromCharCodes(data) == 
                  "mensagem enviada pelo clienteClose Server") 
        {
          await closeAllConnections();
        } 
        else 
        {
          if(isServerClosed)
          {
            socket.write(" Server is closed ");
          }
          else
          {
            var recordingDataController = StreamController<Food>();
            _mRecordingDataSubscription = 
                recordingDataController.stream.listen((buffer) async
          {
            if (buffer is FoodData)
            {
              socket.add(buffer.data!);
            }
          });
          await _recorder!.startRecorder(
              toStream: recordingDataController.sink,
              codec: Codec.pcm16,
              numChannels: 1,
              sampleRate: tSampleRate,
           );          
          }
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

  listenConnection(Socket? socket) async 
  {
    socket!.listen((Uint8List data) async
    {
      if (String.fromCharCodes(data).contains("teste")) 
      {
        GlobalUtils.setRoomName(String.fromCharCodes(data));
      } 
      else if (String.fromCharCodes(data).contains("Server is closed")) 
      {
        socket.destroy();
      } 
      else 
      {
        if(!playerStarted)
        {
          await startPlayer();
        }
        await _player!.feedFromStream(data);
      }
    }, 
    onError: (error) 
    {
      socket.close();
      socket.destroy();
    }, onDone: () 
    {
      socket.close();
      socket.destroy();
    });
  }

  static Future<void> closeAllConnections() async 
  {
    isServerClosed = true;
    await server!.close();
    socket!.destroy();
  }

  static void closeClientSocket(context) {
    socket!.destroy();
    Phoenix.rebirth(context);
  }

  Future<void> startPlayer() async
  {
    await _player!.startPlayerFromStream(codec: Codec.pcm16, numChannels: 1, sampleRate: tSampleRate);
    playerStarted = true;

  }

  Future<void> startRecorder() async
  {
    await _recorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );

    recorderStarted = true;
  }
}
