import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoURL;
  final VoidCallback onVideoCompleted;

  const VideoScreen(this.videoURL, {this.onVideoCompleted, Key key})
      : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoURL);

    _videoPlayerController.initialize().then((_) => setState(() {}));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      looping: false,
      showControls: true,
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value != null) {
        var timeToFinish = _videoPlayerController.value.position.inSeconds -
            _videoPlayerController.value.duration.inSeconds;
        if (timeToFinish < 5 && timeToFinish > 0) {
          if (widget.onVideoCompleted != null) {
            widget.onVideoCompleted();
          }
        }
      }
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
