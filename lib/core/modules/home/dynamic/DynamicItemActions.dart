import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePropsWidget.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemActions.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:kindergarten/style/TextStyle.dart';
import 'package:queries/queries.dart';
import 'package:queries/collections.dart';

class DynamicItemActions extends BasePropsWidget {
  DynamicItemActions(Map<String, dynamic> props) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new DynamicItemActionsState();
  }
}

class DynamicItemActionsState extends State<DynamicItemActions> {
  Future<Null> _neverSatisfied() async {
    var textEditingController = new TextEditingController();
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      child: new AlertDialog(
        title: new Text('请输入回复'),
        content: new TextField(
          controller: textEditingController,
          maxLength: 200,
          maxLines: 5,
          autofocus: true,
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('发布回复'),
            onPressed: () {
//              Navigator.of(context).pop();
            print(textEditingController.text);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var likes = widget.props['singleData']['kgDynamicLiked'] as List;
    var fold = (likes).fold(new StringBuffer(), (previousValue, next) {
      previousValue.write(
          widget.props['allClassRoomUserInfo'][next.toString()]== null?"已毕业同学":widget.props['allClassRoomUserInfo'][next.toString()]['nickName']);
      previousValue.write("、");
      return previousValue;
    });
//    allClassRoomUserInfo[list[j]['userId']
    var accentColor = Theme.of(context).accentColor;
    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new IconButton(
              padding: const EdgeInsets.all(10.0),
              icon: new Icon(
                Icons.favorite,
                size: 30.0,
                color: likes.contains(UserProvide.getCacheUser().id.toString())
                    ? accentColor
                    : const Color(0x30808080),
              ),
              onPressed: () {},
            ),
            new IconButton(
              padding: const EdgeInsets.all(10.0),
              icon: new Icon(
                Icons.mode_edit,
                size: 32.0,
                color: const Color(0x30808080),
              ),
              onPressed: widget.props['showCommitBigCommentDialog'],
            ),
            new IconButton(
              padding: const EdgeInsets.all(10.0),
              icon: new Icon(
                Icons.share,
                size: 30.0,
                color: const Color(0x40808080),
              ),
              onPressed: () {},
            ),
          ],
        ),
        new Row(
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
        )
      ],
    );
  }
}
