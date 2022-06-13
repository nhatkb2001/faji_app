import 'package:chewie/chewie.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/views/profile/postListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? src;
  final String? postId;
  final String? uid;
  final String? position;

  VideoWidget({Key? key, this.src, this.postId, this.position, this.uid})
      : super(key: key);

  @override
  _VideoWidget createState() => _VideoWidget();
}

class _VideoWidget extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);
  bool check = false;
  bool play = false;

  void initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);

    await Future.wait([_videoPlayerController.initialize()]);

    _chewieController = ChewieController(
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      showControls: false,
      looping: true,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => postListView(
                      position: widget.position, uid: widget.uid)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Chewie(
            controller: _chewieController,
          ),
        ));
  }
}
