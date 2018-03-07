import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String text;

  final String avatarUrl;

  final bool isContainsAvatar;

  CircleImage({this.text, this.avatarUrl, this.isContainsAvatar});

  @override
  Widget build(BuildContext context) {
    return new CircleAvatar(
      child: isContainsAvatar ? null : new Text(text),
      backgroundImage: isContainsAvatar
          ? new NetworkImage(
              avatarUrl,
            )
          : null,
//                  backgroundColor: Colors.transparent,
    );
  }
}
