import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/dialog/CommitCommentDialog.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicItemActions.dart';
import 'package:queries/collections.dart';

class DynamicComments extends StatefulWidget {
  DynamicComments({this.singleData, this.allClassRoomUserInfo});

  final singleData;
  final allClassRoomUserInfo;

  @override
  State<StatefulWidget> createState() {
    return new DynamicCommentsState();
  }
}

class DynamicCommentsState extends State<DynamicComments> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //所有的按钮和点赞和大评论控件
    var allCommentWidget = [];

    var accentColor = Theme.of(context).accentColor;
    var kgDynamicCommentLists =
        new Collection(widget.singleData['kgDynamicComment']).groupBy((it) {
      return it['groupTag'];
    }).toList();

    var result = {};
    for (var group in kgDynamicCommentLists) {
      result[group.key] = [];
      for (var child in widget.singleData['kgDynamicComment']) {
        if (child['groupTag'] == group.key) {
          result[group.key].add(child);
        }
      }
    }

    allCommentWidget.add(new DynamicItemActions({
      'singleData': widget.singleData,
      'allClassRoomUserInfo': widget.allClassRoomUserInfo,
      'showCommitBigCommentDialog': showCommitBigCommentDialog
    }));

    for (int i = 0; i < result.values.length; i++) {
      var list = result.values.toList()[i];
      if (list is List) {
        //把当前子评论的所有id搞成map
        var allSingeComment = {};
        for (var comment in list) {
          allSingeComment[comment['id'].toString()] = comment;
        }
        //遍历单个大评论的子评论
        for (int j = 0; j < list.length; j++) {
          //单个子评论控件集合
          var singleCommentEntity = list[j];
          singleCommentEntity;
          var singleCommentWidget = [];
          var containsUser = (widget.allClassRoomUserInfo as Map)
              .containsKey(singleCommentEntity['userId'].toString());
          singleCommentWidget.add(
            new TextSpan(
                text: containsUser
                    ? widget.allClassRoomUserInfo[
                        singleCommentEntity['userId'].toString()]['nickName']
                    : "已毕业同学",
                style: new TextStyle(color: accentColor)),
          );
          //如果是第一个,那么就是根评论
          if (j != 0) {
            //回复的用户名字
            var replyUserNickName = widget.allClassRoomUserInfo[allSingeComment[
                        singleCommentEntity['parentCommentId'].toString()]] ==
                    null
                ? "已毕业同学"
                : widget.allClassRoomUserInfo[allSingeComment[
                        singleCommentEntity['parentCommentId'].toString()]
                    ['userId']]['nickName'];
            singleCommentWidget.add(
              new TextSpan(
                text: ' 回复 ',
              ),
            );
            singleCommentWidget.add(
              new TextSpan(
                  text: replyUserNickName,
                  style: new TextStyle(color: accentColor)),
            );
          }

          singleCommentWidget.add(
            new TextSpan(
                text: ': ${singleCommentEntity['commentContent']}',
                style: new TextStyle(fontWeight: FontWeight.bold)),
          );
          allCommentWidget.add(new Align(
            child: new Padding(
                padding: j == 0
                    ? const EdgeInsets.only(
                        left: 0.0,
                      )
                    : const EdgeInsets.only(
                        left: 40.0,
                      ),
                child: new GestureDetector(
                    onTap: () {
//                      singleCommentEntity
                      _neverSatisfied(singleCommentEntity);
                    },
                    child: new RichText(
                      text: new TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: singleCommentWidget,
                      ),
                    ))),
            alignment: Alignment.centerLeft,
          ));
        }
      }
    }
    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: allCommentWidget,
    );
  }

  //显示大评论dialog
  showCommitBigCommentDialog() {
    Map bigCommentParams = {'dynamicId': widget.singleData['id']};
    _neverSatisfied(bigCommentParams);
  }

  Future<Null> _neverSatisfied(parentCommentEntity) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      child: new CommitCommentDialog(
          widget.allClassRoomUserInfo, parentCommentEntity, widget.singleData,
          (callback) {
        this.setState(callback);
      }),
    );
  }
}
