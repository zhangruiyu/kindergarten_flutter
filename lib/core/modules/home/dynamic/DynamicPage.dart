import 'dart:async';

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
        child: new ListView.builder(
          itemCount: localList['dynamics'].length,
//          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return new CustomCard(
                elevation: 1.0,
                padding: const EdgeInsets.fromLTRB(14.0, 15.0, 10.0, 15.0),
                child: new Column(
                  children: <Widget>[
                    new DynamicItemTop(),
                    new DynamicItemCenter(),
                    new DynamicItemActions(),
                    new DynamicItemLikes()
                  ],
                ));
          },
        ));
  }
}

class DynamicItemTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new CircleImage(
          text: 'hhh',
          avatarUrl:
              'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
          isContainsAvatar: true,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: new Text(
            '哈哈哈',
            style: titleStyle.merge(new TextStyle()),
          ),
        ),
        new Text(
          '2018-11-11',
          style: subjectStyle,
        ),
      ],
    );
  }
}

class DynamicItemCenter extends StatelessWidget {
  var aa = [
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1027508095,3429874780&fm=27&gp=0.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: new Text(
            '今天发生特大新闻',
            textAlign: TextAlign.left,
            style: textStyle.merge(new TextStyle()),
          ),
        ),
        new GridView.count(
          primary: false,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          crossAxisCount: 3,
          shrinkWrap: true,
          children: aa.map((item) {
            return new Image.network(aa[0]);
          }).toList(),
        ),
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
            Icons.reply,
            size: 32.0,
          ),
          onPressed: () {},
        ),
        new IconButton(
          padding: const EdgeInsets.all(10.0),
          icon: new Icon(
            Icons.share,
            size: 30.0,
            color: Colors.red,
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
      children: <Widget>[
        new Icon(
          Icons.favorite,
          size: 20.0,
        ),
        new Text(
          '小明妈妈,小红爸爸,小明妈妈,小红爸爸,小明妈妈,小红爸爸',
        ),
      ],
    );
  }
}
