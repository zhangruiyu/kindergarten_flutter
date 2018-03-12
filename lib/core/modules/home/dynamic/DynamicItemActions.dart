import 'package:flutter/material.dart';

class DynamicItemActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new IconButton(
          padding: const EdgeInsets.all(10.0),
          icon: new Icon(
            Icons.favorite,
            size: 30.0,
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
          onPressed: () {},
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
    );
  }
}
