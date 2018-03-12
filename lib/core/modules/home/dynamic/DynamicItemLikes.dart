import 'package:flutter/material.dart';

class DynamicItemLikes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Icon(
          Icons.favorite,
          size: 20.0,
        ),
        new Flexible(
          child: new Text(
            "小明爸爸,小康叔叔,小莉爷爷,小马,小明爸爸,小康叔叔,小莉爷爷,小马,小明爸爸,小康叔叔,小莉爷爷,小马等已点赞",
          ),
          flex: 1,
        ),
      ],
    );
  }
}
