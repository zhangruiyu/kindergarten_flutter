import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/uikit/SubmitButton.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:kindergarten/style/TextStyle.dart';

class InputPasswordPage extends BasePageRoute {
  static const String routeName = '/InputPasswordPage';

  InputPasswordPage([Map<String, String> props]) : super(props);

  @override
  State<StatefulWidget> createState() => new InputPasswordPageState();

  @override
  String getRouteName() {
    return routeName;
  }
}

class InputPasswordPageState extends BasePageState<InputPasswordPage> {
  String password = '123123123';

  void _login() async {
//    await new UserProvide().open();
//    await UserProvide.insert(new UserModel(tel: '15201231806', name: 'aaaaa'));
    /*await UserProvide.getOnlineUser().then((onValue) {
      print(onValue.tel);
    });*/
    if (password.length > 4) {
      RequestHelper.login(widget.props['tel'], password).then((value) {
//        value
        value['isOnline'] = '1';
        UserProvide.save(value);
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
        body: new Container(
          margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
          child: new Column(children: <Widget>[
            new Center(
              child: new Text(
                "登录小助手,体验更多功能",
                style: autoTitleStyle,
              ),
            ),
            new Container(
              child: new TextField(
                maxLength: 11,
                keyboardType: TextInputType.phone,
                // obscureText：是否隐藏正在编辑的文本
                decoration: const InputDecoration(labelText: "登陆密码"),
                style: autoTitleStyle,
                controller: new TextEditingController(text: password),
                onChanged: (String str) {
                  password = str;
                },
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 00.0),
            ),
            new SubmitButton(
              title: '下一步',
              onPress: _login,
            )

            // onSubmitted：当用户在键盘上点击完成编辑时调用
          ]),
        ));
  }
}
