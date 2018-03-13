import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/uikit/CircleImage.dart';
import 'package:kindergarten/style/TextStyle.dart';

class DynamicItemTop extends StatelessWidget {
  DynamicItemTop({this.singleData,this.allClassRoomUserInfo});

  final singleData;
  final allClassRoomUserInfo;

  @override
  Widget build(BuildContext context) {
    final width = window.physicalSize.width / window.devicePixelRatio;
    return new Stack(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new CircleImage(
              text: 'Hi',
              avatarUrl:
                  'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
              isContainsAvatar: true,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: new Text(
                allClassRoomUserInfo[singleData['userId'].toString()]['nickName'],
                style: titleStyle,
              ),
            ),
          ],
        ),
        new Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new SizedBox(
              width: width,
              child: new Text(singleData['createTime'].toString(),
                  style: subjectStyle, textAlign: TextAlign.right),
            )),
      ],
    );
  }
}
