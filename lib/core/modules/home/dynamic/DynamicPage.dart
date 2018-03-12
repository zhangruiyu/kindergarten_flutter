import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicComments.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemActions.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemCenter.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemLikes.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemTop.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/net/RequestHelper.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

// ignore: must_be_immutable
class DynamicPage extends BasePageRoute {
  DynamicPage([Map<String, String> props]) : super(props);

//  final DynamicPageState dynamicPageState = new DynamicPageState();
  DynamicPageState dynamicPageState;

  @override
  State<StatefulWidget> createState() {
    dynamicPageState = new DynamicPageState();
    return dynamicPageState;
  }
}

class DynamicPageState extends BasePageState<DynamicPage> {
  var localList = {'allClassRoomUserInfo': [], 'dynamics': []};
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getDynamics(1).then((data) {
      setState(() {
        localList = data;
      });
      completer.complete(null);
    }).catchError((onError) {
      completer.complete(null);
      setState(() {});
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
  }

  refreshPage() {
    new Timer(
        new Duration(
            milliseconds: _refreshIndicatorKey.currentState == null ? 300 : 0),
        () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: localList != null
            ? new ListView.builder(
                itemCount: localList['dynamics'].length,
//          physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var singleData = localList['dynamics'][index];

                  return new CustomCard(
                      elevation: 1.0,
                      padding:
                          const EdgeInsets.fromLTRB(14.0, 15.0, 10.0, 15.0),
                      child: new Column(
                        children: <Widget>[
                          new DynamicItemTop(singleData: singleData),
                          new DynamicItemCenter(singleData: singleData),
                          new DynamicItemActions(),
                          new DynamicItemLikes(),
                          new DynamicComments(singleData: singleData)
                        ],
                      ));
                },
              )
            : new Text("请登陆后尝试"));
  }
}
