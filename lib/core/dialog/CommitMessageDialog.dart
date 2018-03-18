import 'package:flutter/material.dart';
import 'package:kindergarten/net/RequestHelper.dart';

class CommitMessageDialog extends StatefulWidget {
  CommitMessageDialog({this.callback});

  @override
  State<StatefulWidget> createState() {
    return new CommitMessageDialogState();
  }

  final callback;
}

class CommitMessageDialogState extends State<CommitMessageDialog> {
  var errorText;
  var textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var inputDecoration =
        new InputDecoration(labelText: '消息内容', errorText: errorText);

    return new AlertDialog(
      title: new Text('请输入消息内容'),
      content: new TextField(
        decoration: inputDecoration,
        controller: textEditingController,
        maxLength: 300,
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
          child: new Text('发布'),
          onPressed: () {
            if (textEditingController.text.length >= 4) {
              RequestHelper
                  .commitSchoolMessage(textEditingController.text)
                  .then((value) {
                widget.callback();

                Navigator.of(context).pop();
              })
                    ..catchError((onError) {
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
