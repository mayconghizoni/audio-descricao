import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:acessibility_project/GlobalUtils.dart';
import 'package:acessibility_project/socket_service/WifiController.dart';
import 'package:acessibility_project/sound_service/SoundController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:synchronized/extension.dart';

const int tSampleRate = 16000;

class SocketController 
{
  SoundController soundController = SoundController();
  static WifiController wifiController = new WifiController();

  static ServerSocket? server;
  static Socket? socket;

  static List<String> roomsNames = new List.empty(growable: true);
  static bool isServerClosed = false;

  static FlutterSoundPlayer? _player = FlutterSoundPlayer();
  RecorderStream _recorder = RecorderStream();

  static bool recorderStarted = false;
  static bool playerStarted = false;
  var receptorContext;  

  Future<void> enablePlayer() async {
    _player = await soundController.getSoundPlayer();
  }

  Future<void> createScocket() async {
    String? ip = await wifiController.getIp();
    server = await ServerSocket.bind(ip, 3003);
    isServerClosed = false;

    server?.listen((client) {
      handleConnection(client);
    });
  }

  Future<List> listConnecions() async 
  {
    List<List>? objects = new List.empty(growable: true);
    List<String> ips = new List.empty(growable: true);
    String? ip = await wifiController.getIp();
    ip = ip?.substring(0, ip.lastIndexOf(".") + 1);
    

    for (int i = 50; i < 120; i++) {
      String tempIP = ip! + i.toString();
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


  setReceptorContext(BuildContext context) {
    receptorContext = context;
  }

  handleConnection(Socket socket) 
  {

    StreamSubscription? _audioStream;
    if(!recorderStarted)
    {
      startRecorder();
    }
    
    bool socketOpen = true;
    socket.listen(
      (Uint8List data) {
        if (String.fromCharCodes(data) == "Testing connection") {
          socket.write(GlobalUtils.getRoomName());
        } 
        else if (String.fromCharCodes(data) == 
                  "Close Server") 
        {
           closeAllConnections();
        }
        else if(String.fromCharCodes(data) == "Client left")
        {
          closeClientSocket(receptorContext);
          socketOpen = false;
          socket.done;
        }
        else 
        {
          _audioStream = _recorder.audioStream.listen((data)
          {
            if(isServerClosed)
            {
              socket.write("Server is closed");
              socket.close();
              socket.destroy();
              _audioStream?.cancel();
            }
            else if(!socketOpen)
            {
              socket.close();
              socket.destroy();
              _audioStream?.cancel();
            }
            else
            {    
              socket.add(data);
            }
          });         
        }
      },
      onError: (error) {
        print(error);
        socket.close();
        socket.destroy();
      },
      onDone: () {
        socketOpen = false;
        print("Client left");
        socket.close();
        socket.destroy();
      },
    );
  }

  listenConnection(Socket? socket) {
    socket!.listen((Uint8List data) async {
      if (String.fromCharCodes(data).contains("teste")) {
        GlobalUtils.setRoomName(String.fromCharCodes(data));
      } 
      else if (String.fromCharCodes(data).contains("Server is closed")) 
      {
        _player!.stopPlayer();
        playerStarted = false;
        socket.destroy();
        Phoenix.rebirth(receptorContext);
      } else {
        if (!playerStarted) {
          await startPlayer();
        }
        synchronized(() => _player!.feedFromStream(data));
      }
    }, onError: (error) {
      socket.close();
      socket.destroy();
    }, onDone: () {
      socket.close();
      socket.destroy();
    });
  }

  static Future<void> closeAllConnections() async {
    isServerClosed = true;
    server!.close();
    socket!.close();
    socket!.destroy();
  }

  Future<void> stopAudioSession() async
  {
    if(!(_player!.isStopped))
    {
      _player!.stopPlayer();
    }
  }

  static void closeClientSocket(context) {
    _player!.stopPlayer();
    socket!.close();
    socket!.destroy();
    Phoenix.rebirth(context);
  }

  Future<void> startPlayer() async {
    await _player!.startPlayerFromStream(
        codec: Codec.pcm16, numChannels: 1, sampleRate: tSampleRate);
    playerStarted = true;
  }

  Future<void> startRecorder() async
  {
    _recorder.initialize();
    _recorder.start();
    recorderStarted = true;
  }
}
