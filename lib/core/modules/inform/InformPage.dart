import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/inform/InformItemView.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';

class InformPage extends BasePageRoute {
  static const String routeName = '/InformPage';

  InformPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new InformPageState();
  }
}

class InformPageState extends BasePageState<InformPage> {
  var informData = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 300), () {
      refreshIndicatorKey.currentState.show();
    });
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getInforms(0).then((data) {
      setState(() {
//        localList['dynamics'] = data['dynamics'];
//
//        var allClassRoomUserInfo = data['allClassRoomUserInfo'];
//        if (allClassRoomUserInfo is List && allClassRoomUserInfo.length > 0) {
//          localList['allClassRoomUserInfo'] = data['allClassRoomUserInfo'];
//        }
//        print(localList['allClassRoomUserInfo'].length);
        informData = data;
      });
      completer.complete(null);
    }).catchError((onError) {
      completer.complete(null);
      setState(() {});
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('通知'),
        ),
        body: new RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new ListView.builder(
              itemCount: informData.length,
//          physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var singleData = informData[index];

                return new InformItemView(singleData: singleData);
              },
            )));
  }
}
