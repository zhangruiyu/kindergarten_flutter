import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/net/RequestHelper.dart';

class EditDynamicPage extends BasePageRoute {
  static const String routeName = '/EditDynamicPage';

  @override
  String getRouteName() {
    return routeName;
  }

  EditDynamicPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new EditDynamicPageState();
  }
}

class EditDynamicPageState extends BasePageState<EditDynamicPage> {
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
        appBar: new AppBar(title: new Text('发布动态'), actions: [
          new IconButton(
            icon: const Icon(Icons.send),
            tooltip: '提交修改',
            onPressed: () {
//        commitChange();
            },
          )
        ]),
        body: Container(
          padding: const EdgeInsets.all(8.0),
//          constraints: BoxConstraints(minHeight: 120.0),
          child: Column(
            children: <Widget>[
              new TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(hintText: '请输入内容...'),
              ),
            ],
          ),
        ));
  }
}
