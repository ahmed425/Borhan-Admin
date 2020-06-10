import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class VideoPlayerScreen extends StatefulWidget {
  static const routeName = '/video';
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.asset('assets/demo/borhan.mp4');
    
//     network(
//       'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
// //      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('فيديو توضيحي'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
//      body: Center(
//        child:
//        ClipRRect(
//          borderRadius: new BorderRadius.circular(24.0),
//          child: FutureBuilder(
//            future: _initializeVideoPlayerFuture,
//            builder: (context, snapshot) {
//              if (snapshot.connectionState == ConnectionState.done) {
//                // If the VideoPlayerController has finished initialization, use
//                // the data it provides to limit the aspect ratio of the video.
//                return Container(
//                  height: deviceSize.height,
//                  width: deviceSize.width,
//                  child: AspectRatio(
////                aspectRatio: _controller.value.aspectRatio,
//                    aspectRatio: _controller.value.aspectRatio,
//                    // Use the VideoPlayer widget to display the video.
//                    child: VideoPlayer(
//                      _controller,
//                    ),
//                  ),
//                );
//              } else {
//                // If the VideoPlayerController is still initializing, show a
//                // loading spinner.
//                return Center(child: CircularProgressIndicator());
//              }
//            },
//          ),
//        ),
//      ),

      body: Center(
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            print(details);
            _previousScale = _scale;
            setState(() {});
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            print(details);
            _scale = _previousScale * details.scale;
            setState(() {});
          },
          onScaleEnd: (ScaleEndDetails details) {
            print(details);

            _previousScale = 1.0;
            setState(() {});
          },
          child: RotatedBox(
            quarterTurns: 0,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(24.0),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the VideoPlayerController has finished initialization, use
                        // the data it provides to limit the aspect ratio of the video.
                        return Container(
                          height: deviceSize.height,
                          width: deviceSize.width,
                          child: AspectRatio(
//                aspectRatio: _controller.value.aspectRatio,
                            aspectRatio: _controller.value.aspectRatio,
                            // Use the VideoPlayer widget to display the video.
                            child: VideoPlayer(
                              _controller,
                            ),
                          ),
                        );
                      } else {
                        // If the VideoPlayerController is still initializing, show a
                        // loading spinner.
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
