import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/SK.dart';
import 'package:kindergarten/core/modules/home/entity/ItemEntitys.dart';
import 'package:kindergarten/core/uikit/CustomCard.dart';
import 'package:kindergarten/core/utils/SnackBarUtils.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:refresh_wow/refresh_wow.dart';

typedef void BannerTapCallback(HomeItemWidget photo);

class UserInfoPage extends BasePageRoute {
  UserInfoPage([Map<String, dynamic> props]) : super(props);

  @override
  String getRouteName() {
    return routeName;
  }

  static get routeName => '/UserInfoPage';

  @override
  State<StatefulWidget> createState() => new UserInfoPageState();
}

class UserInfoPageState extends BasePageState<UserInfoPage> {
  static final GlobalKey<RefreshIndicatorState> albumPageRefreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  TextEditingController nameEditingController;
  TextEditingController addressEditingController;

  @override
  void initState() {
    super.initState();
    var cacheUser = UserHelper.getCacheUser();
    addressEditingController =
        new TextEditingController(text: cacheUser.address);
    sexRadioValue = int.parse(cacheUser.gender);
    radioValue = int.parse(cacheUser.relation);
  }

  @override
  void dispose() {
    super.dispose();
    addressEditingController.dispose();
    nameEditingController.dispose();
  }

  int sexRadioValue = 0;
  int radioValue = 0;
  String avatarUrl = '';

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  void handleSexRadioValueChanged(int value) {
    setState(() {
      sexRadioValue = value;
    });
  }

  void commitChange() {
    var cacheUser = UserHelper.getCacheUser();
    if (sexRadioValue == int.parse(cacheUser.gender) &&
        radioValue == int.parse(cacheUser.relation) &&
        addressEditingController.text == cacheUser.address &&
        cacheUser.avatar == avatarUrl) {
      SnackBarUtils.showSnackBar(scaffoldStateKey.currentState, '与原信息一致,请修改后再试',
          isSuccess: false);
    } else {
      RequestHelper
          .reviseProfile(sexRadioValue, radioValue,
              addressEditingController.text, cacheUser.avatar)
          .then((data) {
        UserHelper.saveAndUpdate(() {
          cacheUser.avatar = data['avatarUrl'].toString();
          cacheUser.address = data['address'].toString();
          cacheUser.gender = data['checkGender'].toString();
          cacheUser.relation = data['relationCheck'].toString();
        });
        SnackBarUtils.showSnackBar(scaffoldStateKey.currentState, '信息修改成功',
            listener: Navigator.of(context).pop);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cacheUser = UserHelper.getCacheUser();
    var accentColor = Theme.of(context).accentColor;
    return new Scaffold(
      key: scaffoldStateKey,
      appBar: new AppBar(title: new Text('编辑个人信息'), actions: [
        new IconButton(
          icon: const Icon(Icons.send),
          tooltip: '提交修改',
          onPressed: () {
            commitChange();
          },
        )
      ]),
      body: new Padding(
        padding: const EdgeInsets.only(right: 40.0, left: 20.0),
        child: new Column(
          children: [
            new Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 30.0),
              child: new CircleAvatar(
                  radius: 30.0,
                  backgroundImage: new CachedNetworkImageProvider(
                      UserHelper.getCacheUser().avatar)),
            ),
            new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
              new Icon(
                Icons.person,
                color: accentColor,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: new Text(cacheUser.nickName),
              )
            ]),
            new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
              new Image.asset(
                'images/sexm.png',
                color: accentColor,
                width: 25.0,
              ),
              new Radio(
                  value: 1,
                  groupValue: sexRadioValue,
                  onChanged: handleSexRadioValueChanged),
              new Text('男'),
              new Radio<int>(
                  value: 0,
                  groupValue: sexRadioValue,
                  onChanged: handleSexRadioValueChanged),
              new Text('女'),
            ]),
            new SizedBox(
              child: new Text(
                '与园中宝贝的关系',
                style: new TextStyle(color: accentColor),
                textAlign: TextAlign.start,
              ),
              width: WindowUtils.getScreenWidth(),
            ),
            new Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  new Radio<int>(
                      value: 0,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('父亲'),
                  new Radio<int>(
                      value: 1,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('母亲'),
                  new Radio<int>(
                      value: 2,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('爷爷'),
                  new Radio<int>(
                      value: 3,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('奶奶'),
                  new Radio<int>(
                      value: 4,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('外婆'),
                  new Radio<int>(
                      value: 5,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('外公'),
                  new Radio<int>(
                      value: 6,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged),
                  new Text('其他'),
                ]),
            new TextField(
              controller: addressEditingController,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.location_on),
                  labelText: '添加居住地,以便园方及时联系'),
            ),
          ],
        ),
      ),
    );
  }
}
