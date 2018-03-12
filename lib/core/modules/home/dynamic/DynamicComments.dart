import 'package:flutter/material.dart';
import 'package:queries/queries.dart';
import 'package:queries/collections.dart';

class DynamicComments extends StatelessWidget {
  DynamicComments({this.singleData});

  final singleData;

  @override
  Widget build(BuildContext context) {
    var list = new Collection(singleData['kgDynamicComment']).groupBy((it) {
      print(it['groupTag']);
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
          print(list[j]);
          if (j == 0) {
            bb.add(new Align(
              child: new Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: new Text(
                  list[j]['commentContent'],
                  textAlign: TextAlign.start,
                ),
              ),
              alignment: Alignment.centerLeft,
            ));
          } else {
            bb.add(new Align(
              child: new Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                ),
                child: new Text(
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
    print(result.values);
    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: bb,
    );
  }
}
