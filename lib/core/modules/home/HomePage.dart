import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

final List<HomeItemWidget> firstLine = <HomeItemWidget>[
  new HomeItemWidget(
    url: 'homepage_all_message.png',
    title: '通知',
  ),
  new HomeItemWidget(
    url: 'homepage_school_message.png',
    title: '校园消息',
  ),
  new HomeItemWidget(
    url: 'homepage_eat.png',
    title: '饮食日历',
  ),
];
final List<HomeItemWidget> secondLine = <HomeItemWidget>[
  new HomeItemWidget(
    url: 'homepage_album.png',
    title: '班级相册',
  ),
  new HomeItemWidget(
    url: 'homepage_video.png',
    title: '在线视频',
  ),
  new HomeItemWidget(
    url: 'homepage_video.png',
    title: '在线抓娃娃机',
  ),
];

class HomePage extends BasePageRoute {
  HomePage([Map<String, String> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends BasePageState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new SingleChildScrollView(
            child: new Column(
      children: <Widget>[
        //第一行3个标签
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
          child: new Row(
              children: firstLine.map((HomeItemWidget photo) {
            return new HomePageItemWidget(
                photo: photo,
                onBannerTap: (HomeItemWidget photo) {
                  /* setState(() {
                      photo.isFavorite = !photo.isFavorite;
                    });*/
                });
          }).toList()),
        ),
        //第二行3个标签
        new Row(
            children: secondLine.map((HomeItemWidget photo) {
          return new HomePageItemWidget(
              photo: photo,
              onBannerTap: (HomeItemWidget photo) {
                /* setState(() {
                      photo.isFavorite = !photo.isFavorite;
                    });*/
              });
        }).toList()),
      ],
    )));
  }
}

class HomePageItemWidget extends StatelessWidget {
  HomePageItemWidget(
      {Key key, @required this.photo, @required this.onBannerTap})
      : super(key: key);

  final HomeItemWidget photo;
  final BannerTapCallback
      onBannerTap; // User taps on the photo's header or footer.

  @override
  Widget build(BuildContext context) {
    final Widget image = new Flexible(
        flex: 1,
        child: new GestureDetector(
          onTap: () {
            showPhoto(context);
          },
          child: new Center(
              child: new Column(
            children: <Widget>[
              new Image.asset(
                'images/${this.photo.url}',
                width: 50.0,
                height: 50.0,
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: new Text(this.photo.title))
            ],
          )),
        ));
    return image;
  }

  void showPhoto(BuildContext context) {}
}
