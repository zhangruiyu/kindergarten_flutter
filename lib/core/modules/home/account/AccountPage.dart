import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/home/account/AccountTopUI.dart';
import 'package:kindergarten/core/modules/home/account/LoginIconItem.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/modules/setting/SettingPage.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';

final List<HomeItemWidget> accountCenterItemList = <HomeItemWidget>[
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "积分商城"),
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "充值"),
  new HomeItemWidget(url: "ic_local_grocery_store.png", title: "班级成员"),
];

final List<HomeItemWidget> accountBottomItemList = <HomeItemWidget>[
  new HomeItemWidget(url: "ic_local_grocery_store.png",
      title: "账号安全",
      routeName: SettingPage.routeName),
  new HomeItemWidget(url: "ic_settings_black.png",
      title: "关于",
      routeName: SettingPage.routeName),
];

class AccountPage extends BasePageRoute {
  AccountPage([Map<String, String> props])
      : super(props, key: SK.accountPageStateKey);

  @override
  State<StatefulWidget> createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends BasePageState<AccountPage> {
  var accountProfile;

  refreshPage() async {
    if (UserProvide.haveOnlineUser()) {
      RequestHelper.getAccountProfile().then((data) {
        setState(() {
          accountProfile = data;
          UserProvide.saveAndUpdate(() {
            UserProvide
                .getCacheUser()
                .roleCode =
            accountProfile['roleCode'];
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
    return new Scaffold(
      body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              //第一行3个标签
              new Container(
                margin: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: new Card(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                      child: new Center(
                          child: new AccountTopUI({
                            'cbk': refreshPage,
                            'accountProfile': accountProfile,
                          })),
                    )),
                //第二行3个标签
              ),
              //中间卡片
              new Card(
                elevation: 1.0,
                child: new Column(
                    children: accountCenterItemList.map((item) {
                      return new LoginIconItem(
                        icon: item.url,
                        onPressed: () {
                          /*_scaffoldKey.currentState.showSnackBar(const SnackBar(
                  content: const Text('Pretend that this opened your SMS application.')
              ));*/
                        },
                        text: item.title,
                      );
                    }).toList()),
              ),
              //底部卡片
              new Card(
                elevation: 1.0,
                child: new Column(
                    children: accountBottomItemList.map((item) {
                      return new LoginIconItem(
                        icon: item.url,
                        onPressed: () {
                          Navigator
                              .of(context)
                              .push(new MaterialPageRoute<bool>(
                            builder: (BuildContext context) {
                              return new SettingPage(
                                  {'cbk': refreshPage});
                            },
                          ));
                        },
                        text: item.title,
                      );
                    }).toList()),
              ),
            ],
          )),
    );
  }
}
