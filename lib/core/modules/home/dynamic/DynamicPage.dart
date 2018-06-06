import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/auth/LoginPage.dart';
import 'package:kindergarten/repository/UserModel.dart';
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

class DynamicPage extends BasePageRoute {
  DynamicPage([Map<String, String> props]) : super(props);

  @override
  State<StatefulWidget> createState() => new DynamicPageState();

  static String routeName = 'DynamicPage';

  @override
  String getRouteName() {
    return routeName;
  }
}

class DynamicPageState extends BasePageState<DynamicPage> {
  static var localList = {'allClassRoomUserInfo': [], 'dynamics': []};
  var pageIndex = 0;
  var hasMore = false;
  GlobalKey<RefreshListViewState> refreshListViewStateKey =
      new GlobalKey<RefreshListViewState>();

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
      print('hasMore$hasMore');
      refreshListViewStateKey.currentState
          ?.setData(localList['dynamics'], hasMore ? _handleLoadMore : null);
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
    SK.dynamicRefreshIndicatorKey.currentState?.show();
  }

  refreshBackgroundPage() {
    _fetchData().future.then((v) {}).catchError(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(hasMore);
    var allClassRoomUserInfo = localList['allClassRoomUserInfo'];
    var allClassRoomUserMap = {};
    for (var value in allClassRoomUserInfo) {
      allClassRoomUserMap[value['userId']] = value;
    }
    return UserHelper.getCacheUser() != null
        ? new RefreshIndicator(
            key: SK.dynamicRefreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new RefreshListView(
              refreshListViewKey: refreshListViewStateKey,
              itemData: localList['dynamics'],
              onLoadMore: hasMore ? _handleLoadMore : null,
//          physics: AlwaysScrollableScrollPhysics(),
              itemBuilder:
                  (BuildContext context, int index, dynamic singleData) {
                return new CustomCard(
                    elevation: 1.0,
                    padding: const EdgeInsets.fromLTRB(14.0, 15.0, 10.0, 15.0),
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
            ))
        : new Center(
            child: new GestureDetector(
              child: new Text("请登陆后尝试"),
              onTap: () {
                LoginPage.start(context, {'cbk': _handleRefresh});
              },
            ),
          );
  }
}
