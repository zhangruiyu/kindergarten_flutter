import 'package:flutter/material.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';

class InformItemView extends StatelessWidget {
  InformItemView({this.singleData});

  final dynamic singleData;

  @override
  Widget build(BuildContext context) {
    return new CustomCard(
      elevation: 1.0,
      horizontalMargin: 14.0,
      padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: new Wrap(children: <Widget>[
        new Text(singleData['message']),
        new SizedBox(
          width: WindowUtils.getScreenWidth() - 28,
          child: new Text(
            singleData['createTime'],
            textAlign: TextAlign.right,
          ),
        )
      ]),
    );
  }
}
