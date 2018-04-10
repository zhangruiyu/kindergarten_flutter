import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:refresh_wow/refresh_wow.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

class AlbumPage extends BasePageRoute {
  AlbumPage([Map<String, String> props]) : super(props);

  static get routeName => '/AlbumPage';

  @override
  State<StatefulWidget> createState() => new AlbumPageState();

  @override
  String getRouteName() {
    return routeName;
  }
}

class AlbumPageState extends BasePageState<AlbumPage> {
  final GlobalKey<RefreshIndicatorState> albumPageRefreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List localList = [];

//  List<Map<String, List<Map>>>localList = [];

  Future<Null> _handleRefresh() {
    return _fetchData().future;
  }

  Completer<Null> _fetchData() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getSchoolAlbum().then((data) {
      completer.complete(null);
      setState(() {
        localList = data;
      });
    });
    return completer;
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: refreshDelay), () {
      albumPageRefreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('校园相册'),
        ),
        body: new RefreshListView(
          refreshIndicatorKey: albumPageRefreshIndicatorKey,
          itemData: localList,
          onRefresh: _handleRefresh,
//          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index, dynamic singleData) {
            return new CustomCard(
                elevation: 1.0,
                padding: const EdgeInsets.fromLTRB(14.0, 15.0, 10.0, 15.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: new Text(singleData['data'].toString(),
                          textAlign: TextAlign.left),
                    ),
                    new GridView.count(
                      primary: false,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: singleData['addition'].map((picItem) {
                        print(picItem);
                        return picItem['picUrl'];
                      }).map<Widget>((item) {
                        return new CachedNetworkImage(
                          imageUrl: item,
                          errorWidget: new Icon(Icons.error),
                        );
                      }).toList(),
                    )
                  ],
                ));
          },
        ));
  }
}
