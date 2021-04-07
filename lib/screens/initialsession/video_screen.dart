import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoURL;

  const VideoScreen(this.videoURL, {Key key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  void listener() {
    // if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    //   setState(() {});
    // }
  }
  VideoPlayerController _videoPlayerController;
  // YoutubePlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoURL);

    _videoPlayerController.addListener(() {
      setState(() {});
    });

    _videoPlayerController.initialize().then((_) => setState(() {}));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
    _chewieController.addListener(() {
      int wurst = 5;
    });
  }

  @override
  void dispose() {
    // _controller.close();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Chewie(
      controller: _chewieController,
    ));
  }
}
