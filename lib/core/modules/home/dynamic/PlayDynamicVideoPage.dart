import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

// ignore: must_be_immutable

class PlayDynamicVideoPage extends BasePageRoute {
  PlayDynamicVideoPage([Map<String, String> props]) : super(props) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  @override
  State<StatefulWidget> createState() {
    return new PlayDynamicVideoPageState();
  }
}

class PlayDynamicVideoPageState extends BasePageState<PlayDynamicVideoPage> {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController(
      widget.props['videoUrl']
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new AspectRatio(
            aspectRatio: 9 / 16,
            child: new VideoPlayer(_controller),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: topPadding),
            child: new BackButton(
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed:
            _controller.value.isPlaying ? _controller.pause : _controller.play,
        child: new Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
