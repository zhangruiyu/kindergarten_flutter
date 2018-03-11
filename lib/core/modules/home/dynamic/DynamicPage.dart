import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/uikit/CircleImage.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/style/TextStyle.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

class DynamicPage extends BasePageRoute {
  DynamicPage([Map<String, String> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new DynamicPageState();
  }
}

class DynamicPageState extends BasePageState<DynamicPage> {
  var localList = {'allClassRoomUserInfo': [], 'dynamics': []};
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getDynamics(1).then((data) {
      setState(() {
        localList = data;
      });
      completer.complete(null);
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    new Timer(const Duration(milliseconds: 300), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: localList != null
            ? new ListView.builder(
          itemCount: localList['dynamics'].length,
//          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var singleData = localList['dynamics'][index];

            return new CustomCard(
                elevation: 1.0,
                padding:
                const EdgeInsets.fromLTRB(14.0, 15.0, 10.0, 15.0),
                child: new Column(
                  children: <Widget>[
                    new DynamicItemTop(singleData: singleData),
                    new DynamicItemCenter(singleData: singleData),
                    new DynamicItemActions(),
                    new DynamicItemLikes()
                  ],
                ));
          },
        )
            : null);
  }
}

class DynamicItemTop extends StatelessWidget {
  DynamicItemTop({this.singleData});

  final singleData;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new CircleImage(
          text: 'Hi',
          avatarUrl:
          'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
          isContainsAvatar: true,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: new Text(
            singleData['nickName'].toString(),
            style: titleStyle,
          ),
        ),
        new Text(
          singleData['createTime'].toString(),
          style: subjectStyle,
        ),
      ],
    );
  }
}

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
