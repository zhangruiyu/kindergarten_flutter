import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePropsWidget.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemActions.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:kindergarten/style/TextStyle.dart';

class DynamicItemActions extends BasePropsWidget {
  DynamicItemActions(Map<String, dynamic> props) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new DynamicItemActionsState();
  }
}

class DynamicItemActionsState extends State<DynamicItemActions> {

  @override
  Widget build(BuildContext context) {
    var likes = widget.props['singleData']['kgDynamicLiked'] as List;
    var fold = (likes).fold(new StringBuffer(), (previousValue, next) {
      previousValue.write(
          widget.props['allClassRoomUserInfo'][next.toString()] == null
              ? "已毕业同学"
              : widget.props['allClassRoomUserInfo'][next
              .toString()]['nickName']);
      previousValue.write("、");
      return previousValue;
    });
//    allClassRoomUserInfo[list[j]['userId']
    var accentColor = Theme
        .of(context)
        .accentColor;
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
                color: likes.contains(UserHelper
                    .getCacheUser()
                    .id
                    .toString())
                    ? accentColor
                    : const Color(0x30808080),
              ),
              onPressed: () {
                UserHelper.loginChecked(context, () {
                  if (!likes.contains(UserHelper
                      .getCacheUser()
                      .id
                      .toString())) {
                    RequestHelper.commitDynamicLiked(
                        widget.props['singleData']['id']).then((onValue) {
                      setState(() {
                        likes.add(UserHelper
                            .getCacheUser()
                            .id);
                      });
                    }).catchError((onError) {});
                  }
                });
              },
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
        likes.length > 0 ?
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
                    .merge(new TextStyle(color: Theme
                    .of(context)
                    .accentColor)),
              ),
              flex: 1,
            ),
          ],
        ) : null
      ].where((object) => object != null).toList(),
    );
  }
}
