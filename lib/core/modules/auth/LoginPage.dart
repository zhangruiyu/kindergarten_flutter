import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/auth/InputPasswordPage.dart';
import 'package:kindergarten/core/uikit/SubmitButton.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/style/TextStyle.dart';

class LoginPage extends BasePageRoute {
  static const String routeName = '/LoginPage';

  LoginPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() => new LoginPageState(props);
}

class LoginPageState extends BasePageState<LoginPage> {
  String tel = '15201231805';

  LoginPageState(Map<String, dynamic> props) : super(props);

  void _login() async {
    if (tel.length < 11) {}
    RequestHelper.verifyIsRegister(tel).then((value) {
      if (value['data'] == '1') {
        Navigator.of(context).push(new MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return new InputPasswordPage({'tel': tel});
          },
        ));
      } else {}
    });
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
                decoration: const InputDecoration(labelText: "手机号"),
                style: autoTitleStyle,
                controller: new TextEditingController(text: tel),
                onChanged: (String str) {
                  tel = str;
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
