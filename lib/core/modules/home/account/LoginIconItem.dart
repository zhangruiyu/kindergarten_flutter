import 'package:flutter/material.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';

class LoginIconItem extends StatelessWidget {
  LoginIconItem({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  final String icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new FlatButton(
        onPressed: this.onPressed,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
        child: new Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          new Image.asset(
            'images/$icon',
            width: 20.0,
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: new Text(text, style: themeData.textTheme.subhead),
          )
        ]));
  }
}
