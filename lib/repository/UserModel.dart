//tel        VARCHAR PRIMARY KEY,
//    name       VARCHAR,
//token      VARCHAR,
//    isOnline   VARCHAR,
//nickName   VARCHAR,
//    roleCode   VARCHAR,
//avatar     VARCHAR,
//    gender     VARCHAR,
//address    VARCHAR,
//    relation   VARCHAR,
//ysToken    VARCHAR,
//    schoolName VARCHAR,
//qqOpenId   VARCHAR,
//    wxOpenId   VARCHAR,
//qqNickName VARCHAR,
//    wxNickName VARCHAR

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/auth/LoginPage.dart';

final String UserTalbeName = "k_user_table";

final String ID = "id";
final String TEL = "tel";
final String TOKEN = "token";
final String ISONLINE = "isOnline";
final String NICKNAME = "nickName";
final String ROLECODE = "roleCode";
final String AVATAR = "avatar";
final String GENDER = "gender";
final String ADDRESS = "address";
final String RELATION = "relation";
final String YSTOKEN = "ysToken";
final String SCHOOLNAME = "schoolName";
final String QQOPENID = "qqOpenId";
final String WXOPENID = "wxOpenId";
final String QQNICKNAME = "qqNickName";
final String WXNICKNAME = "wxNickName";
final List<String> UserTalbeCloum = [
  ID,
  TEL,
  TOKEN,
  ISONLINE,
  NICKNAME,
  ROLECODE,
  AVATAR,
  GENDER,
  ADDRESS,
  RELATION,
  YSTOKEN,
  SCHOOLNAME,
  QQOPENID,
  WXOPENID,
  QQNICKNAME,
  WXNICKNAME
];
final String userTableSql = '''
              CREATE TABLE 
$UserTalbeName (
                        tel        VARCHAR PRIMARY KEY,
                        id      VARCHAR,
                        token      VARCHAR,
                        isOnline   VARCHAR,
                        nickName   VARCHAR,
                        roleCode   VARCHAR,
                        avatar     VARCHAR,
                        gender     VARCHAR,
                        address    VARCHAR,
                        relation   VARCHAR,
                        ysToken    VARCHAR,
                        schoolName VARCHAR,
                        qqOpenId   VARCHAR,
                        wxOpenId   VARCHAR,
                        qqNickName VARCHAR,
                        wxNickName VARCHAR
                      )
              ''';

class UserModel {
  String id;

  String tel;

  String token;

  String isOnline;

  String nickName;

  String roleCode;

  String avatar;

  String gender;

  String address;

  String relation;

  String ysToken;

  String schoolName;

  String qqOpenId;

  String wxOpenId;

  String qqNickName;

  String wxNickName;

  UserModel(
      {this.id,
      this.tel,
      this.token,
      this.isOnline,
      this.nickName,
      this.roleCode,
      this.avatar,
      this.gender,
      this.address,
      this.relation,
      this.ysToken,
      this.schoolName,
      this.qqOpenId,
      this.wxOpenId,
      this.qqNickName,
      this.wxNickName});

  UserModel.fromMap(Map map) {
    id = map[ID];
    tel = map[TEL];
    token = map[TOKEN];
    isOnline = map[ISONLINE];
    nickName = map[NICKNAME];
    roleCode = map[ROLECODE];
    avatar = map[AVATAR];
    gender = map[GENDER];
    address = map[ADDRESS];
    relation = map[RELATION];
    ysToken = map[YSTOKEN];
    schoolName = map[SCHOOLNAME];
    qqOpenId = map[QQOPENID];
    wxOpenId = map[WXOPENID];
    qqNickName = map[QQNICKNAME];
    wxNickName = map[WXNICKNAME];
  }

  Map toMap() {
    HashMap<String, dynamic> map = new HashMap<String, dynamic>();
    if (id != null) {
      map[ID] = id;
    }
    if (tel != null) {
      map[TEL] = tel;
    }
    if (token != null) {
      map[TOKEN] = token;
    }
    if (isOnline != null) {
      map[ISONLINE] = isOnline;
    }
    if (nickName != null) {
      map[NICKNAME] = nickName;
    }
    if (roleCode != null) {
      map[ROLECODE] = roleCode;
    }
    if (avatar != null) {
      map[AVATAR] = avatar;
    }
    if (gender != null) {
      map[GENDER] = gender;
    }
    if (address != null) {
      map[ADDRESS] = address;
    }
    if (relation != null) {
      map[RELATION] = relation;
    }
    if (ysToken != null) {
      map[YSTOKEN] = ysToken;
    }
    if (schoolName != null) {
      map[SCHOOLNAME] = schoolName;
    }
    if (qqOpenId != null) {
      map[QQOPENID] = qqOpenId;
    }
    if (wxOpenId != null) {
      map[WXOPENID] = wxOpenId;
    }
    if (qqNickName != null) {
      map[QQNICKNAME] = qqNickName;
    }
    if (wxNickName != null) {
      map[WXNICKNAME] = wxNickName;
    }
    return map;
  }
}

class UserProvide {
  static const String SP_USER_INFO = 'SP_USER_INFO';
  static UserModel _userCache;

  static UserModel save(Map user) {
    _userCache = new UserModel.fromMap(user);
    saveData();
    return _userCache;
  }

  static void saveData() {
    sp.setString(SP_USER_INFO,
        _userCache != null ? json.encode(_userCache?.toMap()) : '');
  }
  static void loadData() {
    String localData = sp.getString(SP_USER_INFO);
    //不要去掉问号(..
//    debugPrint(localData);
    if (localData?.isNotEmpty == true) {
      _userCache = new UserModel.fromMap(json.decode(localData));
      print(_userCache);
    } else {
      debugPrint('用户数据为空');
    }
  }

  static loginOut() async {
    _userCache = null;
    sp.setString(SP_USER_INFO, null);
  }

  //更新到内存并写入数据库
  static saveAndUpdate(setUp) {
    setUp();
    saveData();
  }

  static haveOnlineUser() {
    return _userCache != null;
  }

  static UserModel getCacheUser() {
    return _userCache;
  }

  static loginChecked(context, onSuccessCallback, [props = const {}]) {
    if (haveOnlineUser()) {
      onSuccessCallback();
    } else {
      LoginPage.start(context, props);
    }
  }

  //是否是普通人员
  static isNormalPeople() {
    return (UserProvide.getCacheUser().roleCode != null &&
        int.parse(UserProvide.getCacheUser().roleCode) < 1);
  }

  static String getUserToken() {
    if (_userCache != null) {
      return _userCache.token;
    } else {
      return "";
    }
  }

  static String getTokenUrl() {
    return '?token=${getUserToken()}';
  }
}
