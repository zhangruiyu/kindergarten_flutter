import 'dart:async';

import 'package:flutter/material.dart';
import 'package:refresh_wow/refresh_wow.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicComments.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemCenter.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemTop.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/net/RequestHelper.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

// ignore: must_be_immutable
class DynamicPage extends BasePageRoute {
  DynamicPage([Map<String, String> props]) : super(props);


  @override
  State<StatefulWidget> createState() => new DynamicPageState();
}

class DynamicPageState extends BasePageState<DynamicPage> {
  var localList = {'allClassRoomUserInfo': [], 'dynamics': []};
  var pageIndex = 0;
  var hasMore = false;

  Future<Null> _handleRefresh() {
    pageIndex = 0;
    return _fetchData().future;
  }

  Future<Null> _handleLoadMore() {
    return _fetchData().future;
  }

  Completer<Null> _fetchData() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getDynamics(pageIndex).then((data) {
      completer.complete(null);
      setState(() {
        if (pageIndex == 0) {
          localList['dynamics'] = data['dynamics'];
          var allClassRoomUserInfo = data['allClassRoomUserInfo'];
          if (allClassRoomUserInfo is List && allClassRoomUserInfo.length > 0) {
            localList['allClassRoomUserInfo'] = data['allClassRoomUserInfo'];
          }
        } else {
          localList['dynamics'].addAll(data['dynamics']);
        }
        ++pageIndex;
        hasMore = (data['dynamics'] as List).length >= 5;
      });
    }).catchError((onError) {
      completer.complete(null);
      setState(() {});
    });
    return completer;
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
    print(hasMore);
    var allClassRoomUserInfo = localList['allClassRoomUserInfo'];
    var allClassRoomUserMap = {};
    for (var value in allClassRoomUserInfo) {
      allClassRoomUserMap[value['userId']] = value;
    }
    return
      localList != null
          ? new RefreshListView(
        refreshIndicatorKey: SK.dynamicRefreshIndicatorKey,
        itemData: localList['dynamics'],
        onRefresh: _handleRefresh,
        onLoadMore: hasMore ?
        _handleLoadMore
            : null,
//          physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index, dynamic singleData) {
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
                  new DynamicComments(
                      singleData: singleData,
                      allClassRoomUserInfo: allClassRoomUserMap)
                ],
              ));
        },
      )
          : new Text("请登陆后尝试");
  }
}
