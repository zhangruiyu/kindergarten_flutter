import 'package:flutter/material.dart';
import 'package:kindergarten/core/uikit/SubmitButton.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:kindergarten/style/TextStyle.dart';

class InputPasswordPage extends StatefulWidget {
  static const String routeName = '/InputPasswordPage';

  @override
  State<StatefulWidget> createState() => new InputPasswordPageState();
}

class InputPasswordPageState extends State<InputPasswordPage> {
  void _login() async {
//    await new UserProvide().open();
//    await UserProvide.insert(new UserModel(tel: '15201231806', name: 'aaaaa'));
    /*await UserProvide.getOnlineUser().then((onValue) {
      print(onValue.tel);
    });*/
    RequestHelper.verifyIsRegister('15201231805').then((value) {
      if (value['data'] == '1') {}
      print(value);
//      new UserModel(tel: '15201231806', name: 'aaaaa')
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