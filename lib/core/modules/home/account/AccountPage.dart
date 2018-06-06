import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/home/account/AccountTopUI.dart';
import 'package:kindergarten/core/modules/home/account/LoginIconItem.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/modules/setting/SettingPage.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';

final List<HomeItemWidget> accountCenterItemList = <HomeItemWidget>[
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "积分商城"),
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "充值"),
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "班级成员"),
];

final List<HomeItemWidget> accountBottomItemList = <HomeItemWidget>[
  new HomeItemWidget(
      url: "ic_local_grocery_store.png",
      title: "账号安全",
      routeName: SettingPage.routeName),
  new HomeItemWidget(
      url: "ic_settings_black.png",
      title: "关于",
      routeName: SettingPage.routeName),
];

class AccountPage extends BasePageRoute {
  AccountPage([Map<String, String> props])
      : super(props, key: SK.accountPageStateKey);

  static String routeName = 'AccountPage';

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  State<StatefulWidget> createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends BasePageState<AccountPage> {
  var accountProfile;

  refreshPage() async {
    if (UserHelper.haveOnlineUser()) {
      RequestHelper.getAccountProfile().then((data) {
        setState(() {
          accountProfile = data;
          UserHelper.saveAndUpdate(() {
            UserHelper.getCacheUser().roleCode = accountProfile['roleCode'];
            UserHelper.getCacheUser().avatar = accountProfile['avatar'];
            UserHelper.getCacheUser().nickName = accountProfile['nickName'];
            print(accountProfile['roleCode']);
          });
          print('AccountPageState  == ');
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      width: WindowUtils.getScreenWidth() * 0.8,
      child: new Column(
        children: <Widget>[
          //第一行3个标签
          new AccountTopUI({
            'cbk': refreshPage,
            'accountProfile': accountProfile,
          }),
          //中间卡片
          new Column(
              children: accountCenterItemList.map((item) {
            return new ListTile(
              onTap: (){},
              leading: new Image.asset(
                'images/${item.url}',
                width: 20.0,
              ),
              title: new Text(item.title,
                  style: Theme.of(context).textTheme.subhead),
            );
          }).toList()),
          //底部卡片
          new Column(
              children: accountBottomItemList.map((item) {
            return new ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator
                    .of(context)
                    .push(new SettingPage({'cbk': refreshPage}).route());
              },
              leading: new Image.asset(
                'images/${item.url}',
                width: 20.0,
              ),
              title: new Text(item.title,
                  style: Theme.of(context).textTheme.subhead),
            );
          }).toList()),
        ],
      ),
    );
  }
}
