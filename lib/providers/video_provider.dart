import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video with ChangeNotifier {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  Future<VideoPlayerController> setup () async {
    _controller = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
//      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
//    _initializeVideoPlayerFuture = _controller.initialize();
//    _controller.setLooping(true);
    return _controller;
  }

}