import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

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

  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'QTSUm9LId7k',
      params: YoutubePlayerParams(autoPlay: true, showControls: true));
  @override
  void initState() {
    super.initState();
    // _controller = YoutubePlayerController(
    //   initialVideoId: "pfknhYUOsJc",
    //   flags: const YoutubePlayerFlags(
    //     mute: false,
    //     autoPlay: false,
    //     disableDragSeek: false,
    //     loop: false,
    //     isLive: false,
    //     forceHD: false,
    //     enableCaption: true,
    //   ),
    // )..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: YoutubePlayerIFrame(
      controller: _controller,

      // showVideoProgressIndicator: true,
      // onEnded: (endedData) {
      //   Provider.of<InitSessionViewModel>(context)
      //       .onVideoCompleted(this.widget.videoURL);
    ));
    // YoutubePlayerBuilder(
    //     player: YoutubePlayer(
    //       controller: _controller,
    //       liveUIColor: Colors.amber,
    //     ),
    //     builder: (context, player) {
    //       return Scaffold(
    //         body: Container(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [player],
    //           ),
    //         ),
    //         floatingActionButton: FloatingActionButton(
    //           onPressed: () {
    //             Navigator.pushNamed(context, RouteNames.LOG_IN);
    //           },
    //           tooltip: 'Weiter',
    //           child: Icon(Icons.add),
    //         ),
    //       );
    //     });
  }
}
