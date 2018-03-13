import 'package:flutter/material.dart';
import 'package:kindergarten/style/TextStyle.dart';
import 'package:queries/queries.dart';
import 'package:queries/collections.dart';

class DynamicItemLikes extends StatelessWidget {
  DynamicItemLikes({this.singleData, this.allClassRoomUserInfo});

  final singleData;
  final allClassRoomUserInfo;

  @override
  Widget build(BuildContext context) {
    var fold = (singleData['kgDynamicLiked'] as List).fold(new StringBuffer(),
        (previousValue, next) {
      previousValue.write(allClassRoomUserInfo[next.toString()]['nickName']);
      previousValue.write("、");
      return previousValue;
    });
//    allClassRoomUserInfo[list[j]['userId']
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Icon(
          Icons.favorite,
          size: 20.0,
        ),
        new Flexible(
          child: new Text(
            "$fold已点赞",
            style: subjectStyle
                .merge(new TextStyle(color: Theme.of(context).accentColor)),
          ),
          flex: 1,
        ),
      ],
    );
  }
}
