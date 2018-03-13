import 'package:flutter/material.dart';
import 'package:kindergarten/style/TextStyle.dart';
import 'package:queries/queries.dart';
import 'package:queries/collections.dart';

class DynamicComments extends StatelessWidget {
  DynamicComments({this.singleData, this.allClassRoomUserInfo});

  final singleData;
  final allClassRoomUserInfo;

  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;
    var list = new Collection(singleData['kgDynamicComment']).groupBy((it) {
      return it['groupTag'];
    }).toList();

    var result = {};
    for (var group in list) {
      result[group.key] = [];
      for (var child in singleData['kgDynamicComment']) {
        if (child['groupTag'] == group.key) {
          result[group.key].add(child);
        }
      }
    }
    //所有的大评论控件
    var allCommentWidget = [];

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
          var singleCommentWidget = [];
          singleCommentWidget.add(
            new TextSpan(
                text: allClassRoomUserInfo[list[j]['userId'].toString()]
                    ['nickName'],
                style: new TextStyle(color: accentColor)),
          );
          //如果是第一个,那么就是根评论
          if (j != 0) {
            //回复的用户名字
            var replyUserNickName = allClassRoomUserInfo[
                allSingeComment[list[j]['parentCommentId'].toString()]
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
                text: ': ${list[j]['commentContent']}',
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
                child: new RichText(
                  text: new TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: singleCommentWidget,
                  ),
                )),
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
}
