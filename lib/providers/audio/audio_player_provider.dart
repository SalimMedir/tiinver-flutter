// // audio_player_provider.dart
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class AudioPlayerProvider with ChangeNotifier {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   PlayerState _audioPlayerState = PlayerState.stopped;
//   String _currentPlayingUrl = '';
//
//   PlayerState get audioPlayerState => _audioPlayerState;
//   String get currentPlayingUrl => _currentPlayingUrl;
//
//   Future<void> play(String url) async {
//     _currentPlayingUrl = url;
//     await _audioPlayer.play(UrlSource(url));
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       _audioPlayerState = state;
//       notifyListeners();
//     });
//   }
//
//   Future<void> pause() async {
//     await _audioPlayer.pause();
//   }
//
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _audioPlayerState = PlayerState.stopped;
  String _currentPlayingUrl = '';

  AudioPlayerProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _audioPlayerState = state;
      if (state == PlayerState.completed) {
        _audioPlayerState = PlayerState.stopped;
        _currentPlayingUrl = '';
      }
      notifyListeners();
    });
  }

  PlayerState get audioPlayerState => _audioPlayerState;
  String get currentPlayingUrl => _currentPlayingUrl;

  void play(String url) async {
    _currentPlayingUrl = url;
    await _audioPlayer.play(UrlSource(url));
    _audioPlayerState = PlayerState.playing;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _audioPlayerState = PlayerState.paused;
    notifyListeners();
  }
}