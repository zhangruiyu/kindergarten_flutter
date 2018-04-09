import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/cameraplay/ezviz.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';

class CameraListItemView extends StatelessWidget {
  CameraListItemView({this.singleData, this.ezToken});

  final dynamic singleData;
  final String ezToken;

  @override
  Widget build(BuildContext context) {
    List<Widget> classRoomWidgets = [];
    classRoomWidgets.add(
      new Image.asset(
        'images/unwatch.png',
        fit: BoxFit.fitHeight,
        height: 200.0,
        width: WindowUtils.getScreenWidth() - 16,
      ),
    );
    if (singleData['unWatch'].toString() == '1') {
      classRoomWidgets.add(
        new ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: new CachedNetworkImage(
            imageUrl: singleData['classroomImage'],
            fit: BoxFit.fitWidth,
            height: 200.0,
            width: WindowUtils.getScreenWidth() - 16,
          ),
        ),
      );
    }
    classRoomWidgets.add(
      new Container(
        margin: const EdgeInsets.only(top: 166.0, left: 10.0),
        child: new Text(
          '小班',
          textAlign: TextAlign.center,
          style: new TextStyle(color: const Color(0xffffffff)),
        ),
        width: 50.0,
        decoration: new BoxDecoration(
          color: const Color(0xFFFDD835),
          borderRadius: new BorderRadius.circular(18.0),
          border: new Border.all(
            color: const Color(0xFFFDD835),
            width: 2.0,
          ),
        ),
      ),
    );

    return new GestureDetector(
      onTap: () {
        var kgCamera = singleData['kgCamera'];
        if (singleData['unWatch'].toString() == '1') {
          if (kgCamera['deviceSerial'] == null) {
            Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("此教室暂未开放在线摄像头"),
                backgroundColor: Theme.of(context).errorColor));
          }
        } else {
          Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("未到开放时间,请下拉刷新后再次尝试"),
              backgroundColor: Theme.of(context).errorColor));
        }
        Ezviz.startCameraPlayPage(this.ezToken,kgCamera['deviceSerial'],kgCamera['verifyCode'],'1');
      },
      child: new Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: new Stack(children: classRoomWidgets),
      ),
    );
  }
}
