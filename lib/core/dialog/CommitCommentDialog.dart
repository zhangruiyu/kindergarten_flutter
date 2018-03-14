import 'package:flutter/material.dart';
import 'package:kindergarten/net/RequestHelper.dart';

class CommitCommentDialog extends StatefulWidget {
  CommitCommentDialog(this.allClassRoomUserInfo, this.parentCommentEntity,
      this.singleData, this.refreshSingleComment);

  @override
  State<StatefulWidget> createState() {
    return new CommitCommentDialogState();
  }

  final allClassRoomUserInfo;
  final parentCommentEntity;
  final singleData;
  final refreshSingleComment;
}

class CommitCommentDialogState extends State<CommitCommentDialog> {
  var errorText;
  var textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var containsParentCommentId =
        (widget.parentCommentEntity as Map).containsKey('parentCommentId');
    var inputDecoration = new InputDecoration(
        labelText: containsParentCommentId
            ? '回复${widget.allClassRoomUserInfo[
        widget.parentCommentEntity['userId'].toString()]['nickName']}:'
            : '',
        errorText: errorText);

    return new AlertDialog(
      title: new Text('请输入${containsParentCommentId ? '回复' : '评论'}'),
      content: new TextField(
        decoration: inputDecoration,
        controller: textEditingController,
        maxLength: 200,
        maxLines: 5,
        autofocus: true,
        onChanged: (str) {
          print(str);
          setState(() {
            errorText = str.length < 4 ? "输入内容太短" : null;
          });
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('发布回复'),
          onPressed: () {
            if (textEditingController.text.length >= 4) {
              RequestHelper
                  .commitDynamicComment(
                      textEditingController.text,
                      widget.parentCommentEntity['dynamicId'],
                      //如果是大评论,parent写为'0'就好
                      containsParentCommentId
                          ? widget.parentCommentEntity['id']
                          : '0',
                  //如果是大评论,groupTag写为空串就好
                      containsParentCommentId
                          ? widget.parentCommentEntity['groupTag']
                          : '')
                  .then((onValue) {
                widget.refreshSingleComment(() {
                  (widget.singleData['kgDynamicComment'] as List).add(onValue);
                });
                Navigator.of(context).pop();
              }).catchError((onError) {
                setState(() {
                  errorText = "网络请求失败${onError.toString()}";
                });
              });
            }
          },
        ),
      ],
    );
  }
}
