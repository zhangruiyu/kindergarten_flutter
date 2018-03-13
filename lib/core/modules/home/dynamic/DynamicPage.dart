import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/SK.dart';
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

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getDynamics(0).then((data) {
      setState(() {
        localList['dynamics'] = data['dynamics'];

        var allClassRoomUserInfo = data['allClassRoomUserInfo'];
        if (allClassRoomUserInfo is List && allClassRoomUserInfo.length > 0) {
          localList['allClassRoomUserInfo'] = data['allClassRoomUserInfo'];
        }
        print(localList['allClassRoomUserInfo'].length);
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
    SK.dynamicRefreshIndicatorKey.currentState.show();
  }

  @override
  Widget build(BuildContext context) {
    var allClassRoomUserInfo = localList['allClassRoomUserInfo'];
    var allClassRoomUserMap = {};
    for (var value in allClassRoomUserInfo) {
      allClassRoomUserMap[value['userId']] = value;
    }
    return new RefreshIndicator(
        key: SK.dynamicRefreshIndicatorKey,
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
                          new DynamicItemTop(
                              singleData: singleData,
                              allClassRoomUserInfo: allClassRoomUserMap),
                          new DynamicItemCenter(singleData: singleData),
                          new DynamicItemActions(),
                          new DynamicItemLikes(
                              singleData: singleData,
                              allClassRoomUserInfo: allClassRoomUserMap),
                          new DynamicComments(
                              singleData: singleData,
                              allClassRoomUserInfo: allClassRoomUserMap)
                        ],
                      ));
                },
              )
            : new Text("请登陆后尝试"));
  }
}
