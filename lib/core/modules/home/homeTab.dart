import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/editdynamic/EditDynamicPage.dart';
import 'package:kindergarten/core/modules/home/dynamic/DynamicPage.dart';
import 'package:kindergarten/core/modules/home/home/HomePage.dart';
import 'package:kindergarten/repository/UserModel.dart';

class HomeTab extends BasePageRoute {
  static const String routeName = '/material/bottom_navigation';
  final ThemeData themeData;

  HomeTab(this.themeData) : super({}, key: SK.bottomNavigationDemoStateKey);

  @override
  State<StatefulWidget> createState() => new BottomNavigationDemoState();

  @override
  String getRouteName() {
    return routeName;
  }
}

class BottomNavigationDemoState extends State<HomeTab>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;

  HomePage homePage = new HomePage();
  DynamicPage dynamicPage = new DynamicPage({});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<FadeTransition> transitions;

  void changePageByIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      SK.homepageRefreshIndicatorKey.currentState?.show();
    } else if (_currentIndex == 1) {
      SK.dynamicRefreshIndicatorKey.currentState?.show();
    }
//    SK.accountPageStateKey.currentState?.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    //初始页面未点击,但是首页需要数据
    new Timer(new Duration(milliseconds: refreshDelay), () {
      SK.homepageRefreshIndicatorKey.currentState?.show();
    });

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('天云山幼儿园'),
      ),
      body: IndexedStack(
        children: <Widget>[homePage, dynamicPage],
        index: _currentIndex,
      ),
      bottomNavigationBar: new _DemoBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerDocked,
        showNotch: true,
        color: Theme.of(context).accentColor,
        onTap: changePageByIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          UserHelper.loginChecked(context, (){
            Navigator.of(context).push(new EditDynamicPage().route());
          });
        },
        tooltip: '长按发表视频动态',
        child: new Icon(Icons.add),
      ),
    );
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar(
      {this.color, this.fabLocation, this.showNotch, this.onTap});

  final ValueChanged<int> onTap;
  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final bool showNotch;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      new IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          onTap(0);
        },
        color: Colors.white,
      ),
      new IconButton(
        icon: const Icon(Icons.notifications),
        color: Colors.white,
        onPressed: () {
          onTap(1);
        },
      ),
    ];

    return new BottomAppBar(
      color: color,
      hasNotch: showNotch,
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowContents),
    );
  }
}
