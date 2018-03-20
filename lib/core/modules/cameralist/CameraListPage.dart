import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/cameralist/CameraListItemView.dart';
import 'package:kindergarten/core/modules/inform/InformItemView.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';

class CameraListPage extends BasePageRoute {
  static const String routeName = '/CameraListPage';

  CameraListPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new CameraListPageState();
  }
}

class CameraListPageState extends BasePageState<CameraListPage> {
  var cameraListData;
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
    RequestHelper.getCameraList().then((data) {
      setState(() {
        cameraListData = data;
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
          title: new Text('在线宝贝'),
        ),
        body: new RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new ListView.builder(
              itemCount: cameraListData == null
                  ? 0
                  : cameraListData['data'].length + 1,
              physics: new AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: new Text(
                      '摄像头开放时间为: 09:00-10:45 15:30-17:35',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                var singleData = cameraListData['data'][--index];
                return new CameraListItemView(singleData: singleData,ezToken:cameraListData['addition']['data']);
              },
            )));
  }
}
