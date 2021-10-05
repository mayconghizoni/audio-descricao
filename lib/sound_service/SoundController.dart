import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

const int tSampleRate = 16000;

class SoundController
{
  StreamSubscription? _mRecordingDataSubscription;

  static bool isSoundEnabled = false;
  static bool isRecorderEnabled = false;

  static bool isRecorderInitilized = false;
  static bool isSoundInitilized = false;
  
  static FlutterSoundPlayer? _player = FlutterSoundPlayer();
  static FlutterSoundRecorder? _recorder = FlutterSoundRecorder();

  Future<FlutterSoundPlayer?> getSoundPlayer() async
  {
    if(!isSoundInitilized)
    {
      _player = await enableAudioContext();
    }
    return _player;
  }

  Future<FlutterSoundRecorder?> getSoundRecorder() async
  {
    if(!isRecorderInitilized)
    {
      _recorder = await enableRecorderContext();
    }
    return _recorder;
  }

  static Future<FlutterSoundPlayer?> enableAudioContext() async
  {
    isSoundInitilized = true;
    return await _player!.openAudioSession();
  }

  Future<FlutterSoundRecorder?> enableRecorderContext() async
  {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
    {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    isRecorderInitilized = true;
    return await _recorder!.openAudioSession();
  }

  Future<void> playAudioForTest() async
  {

     PermissionStatus status = await Permission.microphone.request();
     if (status != PermissionStatus.granted)
           throw RecordingPermissionException("Microphone permission not granted");

      await openAudioSession();
      var recordingDataController = StreamController<Food>();
          _mRecordingDataSubscription = 
                recordingDataController.stream.listen((buffer) async
          {
            if (buffer is FoodData)
            {
             await _player!.feedFromStream(buffer.data!);
            }
          });

          await _recorder!.startRecorder(
              toStream: recordingDataController.sink,
              codec: Codec.pcm16,
              numChannels: 1,
              sampleRate: tSampleRate,
           );

          await _player!.startPlayer(
              sampleRate: tSampleRate,
              codec: Codec.pcm16,
              numChannels: 1,
          );
  }

  Future<void> openAudioSession() async
  {

      await _recorder!.openAudioSession();

      await _player!.openAudioSession();
  }

  static Future<Uint8List> getAudioStream() async
  {
     var recordingDataController = StreamController<Food>();
     Uint8List audioData = Uint8List(0);
      recordingDataController.stream.listen((buffer) async
      {
      if (buffer is FoodData)
      {
        audioData = buffer.data!;
      }
      });

      await _recorder!.startRecorder(
          toStream: recordingDataController.sink,
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: tSampleRate,
      );

      return audioData;

      
  }

}