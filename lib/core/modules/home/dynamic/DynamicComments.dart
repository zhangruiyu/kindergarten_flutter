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
    var bb = [];

    for (int i = 0; i < result.values.length; i++) {
      var list = result.values.toList()[i];
      if (list is List) {
        for (int j = 0; j < list.length; j++) {
          debugPrint(list[j].toString());
          if (j == 0) {
            bb.add(new Align(
              child: new Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                  ),
                  child: new RichText(
                    text: new TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        new TextSpan(
                            text: allClassRoomUserInfo[
                                    list[j]['userId'].toString()]['nickName'] +
                                ':   '),
                        new TextSpan(
                            text: list[j]['commentContent'],
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              alignment: Alignment.centerLeft,
            ));
          } else {
            bb.add(new Align(
              child: new Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                ),
                child: new Text(
                  allClassRoomUserInfo[list[j]['userId'].toString()]
                          ['nickName'] +
                      ':   ' +
                      list[j]['commentContent'],
                  textAlign: TextAlign.start,
                ),
              ),
              alignment: Alignment.centerLeft,
            ));
          }
        }
      }
    }
    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: bb,
    );
  }
}
