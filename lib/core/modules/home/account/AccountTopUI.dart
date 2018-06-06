import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePropsState.dart';
import 'package:kindergarten/core/base/BasePropsWidget.dart';
import 'package:kindergarten/core/modules/auth/LoginPage.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/modules/userinfo/UserInfoPage.dart';
import 'package:kindergarten/core/uikit/CircleImage.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:kindergarten/style/TextStyle.dart';

final List<HomeItemWidget> loginIconList = <HomeItemWidget>[
  new HomeItemWidget(url: "phone.png", routeName: LoginPage.routeName),
  new HomeItemWidget(url: "ic_qq_login.webp", routeName: LoginPage.routeName),
  new HomeItemWidget(
      url: "ic_wechat_login.webp", routeName: LoginPage.routeName),
];

class AccountTopUI extends BasePropsWidget {
  AccountTopUI(Map<String, dynamic> props) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new AccountTopState();
  }
}

class AccountTopState extends BasePropsState<AccountTopUI> {
  @override
  Widget build(BuildContext context) {
    bool isContainsAvatar = widget.props.containsKey('accountProfile') &&
        widget.props['accountProfile'] != null &&
        widget.props['accountProfile']['avatar'] != null;
    return UserHelper.getCacheUser() != null
        ? new Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 10.0),
            child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      new UserInfoPage({'cbk': widget.props['cbk']}).route());
                },
                child: new Row(
                  children: <Widget>[
                    new CircleImage(
                      isContainsAvatar: isContainsAvatar,
                      text: 'Hi',
                      avatarUrl: isContainsAvatar
                          ? widget.props['accountProfile']['avatar']
                          : '',
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('nick', style: titleStyle),
                          new Text('nick2', style: subjectStyle)
                        ],
                      ),
                    )
                  ],
                )))
        : new Column(
            children: [
              new Text(
                "登陆小助手,体验更多功能",
                style: titleStyle,
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: loginIconList.map((HomeItemWidget loginIcon) {
                    return new Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                        child: new GestureDetector(
                          onTap: () {
                            LoginPage
                                .start(context, {'cbk': widget.props['cbk']});
                          },
                          child: new Image.asset(
                            'images/${loginIcon.url}',
                            width: 40.0,
                            height: 40.0,
                          ),
                        ));
                  }).toList()),
            ],
          );
  }
}
