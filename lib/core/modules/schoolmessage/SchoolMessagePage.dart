import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/dialog/CommitMessageDialog.dart';
import 'package:kindergarten/core/modules/inform/InformItemView.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';

class SchoolMessagePage extends BasePageRoute {
  static const String routeName = '/SchoolMessagePage';

  @override
  String getRouteName() {
    return routeName;
  }
  SchoolMessagePage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new SchoolMessagePageageState();
  }
}

class SchoolMessagePageageState extends BasePageState<SchoolMessagePage> {
  var informData = [];
  var textEditingController = new TextEditingController();
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
    RequestHelper.getSchoolMessage(0).then((data) {
      setState(() {
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
          title: new Text('校园消息'),
        ),
        floatingActionButton: UserHelper.isNormalPeople()
            ? null
            : new FloatingActionButton(
                onPressed: () {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    child: new CommitMessageDialog(
                      callback: refreshIndicatorKey.currentState.show,
                    ),
                  );
                },
                tooltip: '发步校园新消息',
                child: new Icon(Icons.add),
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
