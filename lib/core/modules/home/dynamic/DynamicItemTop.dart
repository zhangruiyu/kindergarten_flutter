import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/uikit/CircleImage.dart';
import 'package:kindergarten/style/TextStyle.dart';

class DynamicItemTop extends StatelessWidget {
  DynamicItemTop({this.singleData, this.allClassRoomUserInfo});

  final singleData;
  final allClassRoomUserInfo;

  @override
  Widget build(BuildContext context) {
    final width = window.physicalSize.width / window.devicePixelRatio;
    var containsKey = (allClassRoomUserInfo as Map)
        .containsKey(singleData['userId'].toString());
    return new Stack(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new CircleImage(
              text: '',
              avatarUrl: containsKey
                  ? allClassRoomUserInfo[singleData['userId'].toString()]
                      ['avatar']
                  : normalAvatarUrl,
              isContainsAvatar: containsKey,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: new Text(
                containsKey
                    ? allClassRoomUserInfo[singleData['userId'].toString()]
                        ['nickName']
                    : "已毕业同学",
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
