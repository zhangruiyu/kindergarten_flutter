import 'package:flutter/material.dart';
import 'package:kindergarten/style/TextStyle.dart';

class DynamicItemCenter extends StatelessWidget {
  DynamicItemCenter({this.singleData});

  final singleData;

  @override
  Widget build(BuildContext context) {
    try {
      print(singleData['kgDynamicVideo']['videoUrl']);
    } catch (e) {} finally {}

    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: new Text(
            singleData['content'],
            textAlign: TextAlign.left,
            style: textStyle,
          ),
        ),
        singleData['dynamicType'] == '0'
            ? new GridView.count(
                primary: false,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: singleData['kgDynamicPics'].map((picItem) {
                  return picItem['picUrl'];
                }).map((item) {
                  return new Image.network(item);
                }).toList(),
              )
            : new Align(
                alignment: Alignment.centerLeft,
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Image.network(
                      singleData['kgDynamicVideo']['videoPic'],
                      height: 250.0,
                    ),
                    new IconButton(
                        icon: new Icon(
                          Icons.play_circle_outline,
                          size: 50.0,
                        ),
                        onPressed: () {}),
                  ],
                ))
      ],
    );
  }
}
