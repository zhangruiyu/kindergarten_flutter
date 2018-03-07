import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/home/HomePage.dart';
import 'package:kindergarten/core/modules/home/NavigationPageView.dart';
import 'package:kindergarten/core/modules/home/account/AccountPage.dart';

class HomeTab extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  ThemeData themeData;

  HomeTab(this.themeData);

  @override
  State<StatefulWidget> createState() =>
      new _BottomNavigationDemoState(themeData);
}

class _BottomNavigationDemoState extends State<HomeTab>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationPageView> _navigationViews;
  ThemeData _themeData;

  _BottomNavigationDemoState(ThemeData themeData) : _themeData = themeData;

  @override
  void initState() {
    super.initState();
    var accentBackgroundColors = _themeData.accentColor;

    _navigationViews = <NavigationPageView>[
      new NavigationPageView(
          icon: const Icon(Icons.home),
          title: '首页',
          color: accentBackgroundColors,
          vsync: this,
          content: new HomePage()),
      new NavigationPageView(
          icon: const Icon(Icons.notifications),
          title: '校友圈',
          color: accentBackgroundColors,
          vsync: this,
          content: new HomePage()),
      new NavigationPageView(
          icon: const Icon(Icons.menu),
          title: '账户',
          color: accentBackgroundColors,
          vsync: this,
          content: new AccountPage()),
    ];

    for (NavigationPageView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationPageView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationPageView view in _navigationViews)
      transitions.add(view.transitionPage(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });
    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationPageView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('天云山幼儿园'),
        actions: <Widget>[
          new PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
                _type = value;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<BottomNavigationBarType>>[
                  const PopupMenuItem<BottomNavigationBarType>(
                    value: BottomNavigationBarType.fixed,
                    child: const Text('Fixed'),
                  ),
                  const PopupMenuItem<BottomNavigationBarType>(
                    value: BottomNavigationBarType.shifting,
                    child: const Text('Shifting'),
                  )
                ],
          )
        ],
      ),
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: '长按发表视频动态',
        child: new Icon(Icons.add),
      ),
    );
  }
}
