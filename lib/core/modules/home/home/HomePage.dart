import 'dart:async';

import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/album/AlbumPage.dart';
import 'package:kindergarten/core/modules/cameralist/CameraListPage.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/modules/inform/InformPage.dart';
import 'package:kindergarten/core/modules/schoolmessage/SchoolMessagePage.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

final List<HomeItemWidget> firstLine = <HomeItemWidget>[
  new HomeItemWidget(
    url: 'homepage_all_message.png',
    title: '通知',
    routeName: InformPage.routeName,
  ),
  new HomeItemWidget(
    url: 'homepage_school_message.png',
    title: '校园消息',
    routeName: SchoolMessagePage.routeName,
  ),
  new HomeItemWidget(
    url: 'homepage_eat.png',
    title: '饮食日历',
    routeName: InformPage.routeName,
  ),
];
final List<HomeItemWidget> secondLine = <HomeItemWidget>[
  new HomeItemWidget(
    url: 'homepage_album.png',
    title: '班级相册',
    routeName: AlbumPage.routeName,
  ),
  new HomeItemWidget(
    url: 'homepage_video.png',
    title: '在线视频',
    routeName: CameraListPage.routeName,
  ),
  new HomeItemWidget(
    url: 'homepage_video.png',
    title: '在线抓娃娃机',
    routeName: InformPage.routeName,
  ),
];

class HomePage extends BasePageRoute {
  HomePage([Map<String, String> props]) : super(props);

//  final HomePageState homePageState = new HomePageState();

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends BasePageState<HomePage> {
  static List bannerData = [];

  refreshPage() async {
    _handleRefresh().then((onValue) {});
  }

  @override
  void initState() {
    super.initState();
//    refreshPage();
  }

  getImage() async {
    var _fileName = await ImagePicker.pickImage();
    print(_fileName);
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getHomepage().then((data) {
      setState(() {
        bannerData = data['data'];
        var addition = data['addition'];
        if (addition > 0) {
          Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("每日登陆积分 +$addition"),
              backgroundColor: Theme.of(context).accentColor));
        }
      });
      completer.complete(null);
    }).catchError((onError) {
      completer.complete(null);
      print(onError);
//      setState(() {});
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        key: SK.homepageRefreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: new SingleChildScrollView(
            physics: new AlwaysScrollableScrollPhysics(),
            child: new Column(
              children: <Widget>[
                new BannerView(
                  data: bannerData,
                  buildShowView: (index, data) {
                    return new BannerShowWidget(data: data);
                  },
                  onBannerClickListener: (index, data) {
                    getImage();
                  },
                ),
                //第一行3个标签
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                  child: new Row(
                      children: firstLine.map((HomeItemWidget photo) {
                    return new HomePageItemWidget(
                        photo: photo,
                        onBannerTap: (HomeItemWidget photo) {
                          UserProvide.loginChecked(context, () {
                            Navigator.of(context).pushNamed(photo.routeName);
                          });
                        });
                  }).toList()),
                ),
                //第二行3个标签
                new Row(
                    children: secondLine.map((HomeItemWidget photo) {
                  return new HomePageItemWidget(
                      photo: photo,
                      onBannerTap: (HomeItemWidget photo) {
                        UserProvide.loginChecked(context, () {
                          Navigator.of(context).pushNamed(photo.routeName);
                        });
                      });
                }).toList()),
              ],
            )));
  }
}

class BannerShowWidget extends StatelessWidget {
  BannerShowWidget({this.data});

  final data;

  @override
  Widget build(BuildContext context) {
    return new CachedNetworkImage(
      imageUrl: data['picUrl'],
      errorWidget: new Icon(Icons.error),
      fit: BoxFit.fill,
      width: WindowUtils.getScreenWidth(),
    );
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
            onBannerTap(photo);
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
}
