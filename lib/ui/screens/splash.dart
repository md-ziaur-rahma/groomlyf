import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatefulWidget {
  Splash({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/back.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
    _controller!.play();
    _controller!.setLooping(true);
    background_video_controller = _controller;
    user_videos = [];
    super.initState();
  /*  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(
            'GGGGGH'
        )));*/
    new Future.delayed(
      const Duration(seconds: 3),
      () async {
      /*  ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:Text(
                'DDDDF'
            )));*/
        await Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Opacity(
          opacity: 1,
          child: _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : Container(),
        ),
      ],
    ));
  }
}
