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

class SocketController {
  SoundController soundController = SoundController();
  static WifiController wifiController = new WifiController();

  static ServerSocket? server;
  static Socket? socket;

  static List<String> roomsNames = new List.empty(growable: true);
  static bool isServerClosed = false;

  static FlutterSoundPlayer? _player = FlutterSoundPlayer();
  RecorderStream _recorder = RecorderStream();
  Stream<Uint8List> stream = new Stream.empty();
  bool streamStarted = false;

  static bool recorderStarted = false;
  static bool playerStarted = false;
  var receptorContext;


  void setReceptorContext(BuildContext context) {
    receptorContext = context;
  }

//----------------------------CONTROLE DE SOCKET---------------------------

  Future<void> createScocket() async {
    String? ip = await wifiController.getIp();
    server = await ServerSocket.bind(ip, 3003);

    isServerClosed = false;
    await createAudioContext(false);

    server?.listen((client) {
      handleConnection(client);
    });
  }

//REFATORAR
  Future<List> listConnecions() async {
    SocketController.roomsNames.clear();
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
    //var initTime = DateTime.now().millisecondsSinceEpoch;
    socket = await Socket.connect(ip, 3003);
    /*
    print("Connected in " +
        (DateTime.now().millisecondsSinceEpoch - initTime).toString());
    print(socket != null ? "Socket connected" : "Error on settingup socket");
    */
    socket?.write("Starting socket");
    return socket;
  }

  void handleConnection(Socket socket) {

    //Stream<Uint8List> stream =_recorder.audioStream.asBroadcastStream();
    //StreamSubscription? _audioStream = _recorder.audioStream.listen();

    if(!streamStarted)
    {
      startStream();
    }

    bool socketOpen = true;
    socket.listen(
      (Uint8List data) {
        String strData = String.fromCharCodes(data);
        switch (strData) {
          case "Testing connection":
            socket.write(GlobalUtils.getRoomName());
            break;
          case "Close Server":
            closeAllConnections();
            break;
          case "Client left":
            closeSocketInstance(receptorContext, socket);
            socketOpen = false;
            socket.done;
            break;
          default:
            stream.listen((data) {
              if (isServerClosed) {
                print("Server is closed!");
                socket.write("Server is closed");
                socket.close();
                socket.destroy();
              } else if (!socketOpen) {
                socket.close();
                socket.destroy();
              } else {
                _player?.feedFromStream(data);
                socket.add(data);
              }
            });
            break;
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

  void listenConnection(Socket? socket) {
    socket!.listen((Uint8List data) async {
      String strData = String.fromCharCodes(data);
      switch (strData) {
        // case "teste":
        //   GlobalUtils.setRoomName(String.fromCharCodes(data));
        //   break;
        case "Server is closed":
          closeSocketInstance(receptorContext, socket);
          break;
        default:
          if (!playerStarted) {
            await createAudioContext(true);
          }
          synchronized(() => _player!.feedFromStream(data));
          break;
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
    socket!.close();
    socket!.destroy();
    server!.close();
  }

  static void closeClientSocket(context) {
    _player!.stopPlayer();
    socket!.close();
    socket!.destroy();
    playerStarted = false;
    Phoenix.rebirth(context);
  }

  void closeSocketInstance(context, Socket? socket) {
    stopAudioSession();
    socket?.close();
    socket?.destroy();
    if (context != null) {
      Phoenix.rebirth(context);
    }
  }

  //---------------------------CONTROLE DE ÁUDIO-----------------------

  void startStream()
  {
    stream = _recorder.audioStream.asBroadcastStream();
    streamStarted = true;
  }

  Future<void> createAudioContext(bool onlyAudio) async {
    print("Inicializando áudio");
    if (!playerStarted) {
      await enablePlayer();
      await startPlayer();
    }
    if (!recorderStarted && !onlyAudio) {
      await startRecorder();
    }
  }

  Future<void> startPlayer() async {
    await _player!.startPlayerFromStream(
        codec: Codec.pcm16, numChannels: 1, sampleRate: tSampleRate);
    playerStarted = true;
  }

  Future<void> startRecorder() async 
  {
    print("Inicializando áudio");
    _recorder.initialize();
    _recorder.start();
    recorderStarted = true;
  }
  Future<void> enableRecorderStream() async
  {
    
    

  }

  Future<void> stopAudioSession() async {
    if (!(_player!.isStopped)) {
      _player!.stopPlayer();
    }
    playerStarted = false;
  }

  Future<void> enablePlayer() async {
    _player = await soundController.getSoundPlayer();
  }
}
