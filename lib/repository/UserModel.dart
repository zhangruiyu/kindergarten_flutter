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

import 'dart:async';
import 'dart:io';

import 'package:kindergarten/repository/KindergartenDatabase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String UserTalbeName = "k_user_table";

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
      {this.tel,
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
    Map map = {};
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
  static UserModel userCache;

  static Future<UserModel> insert(UserModel user) async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    var deleteCode = await db
        .delete(UserTalbeName, where: "$TEL = ?", whereArgs: [user.tel]);
    var code = await db.insert(UserTalbeName, user.toMap());
    db.close();
    return user;
  }

  static Future initOnlineUser() async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    List<Map> maps = await db.query(UserTalbeName,
        columns: UserTalbeCloum, where: "$ISONLINE = ?", whereArgs: ['1']);
    db.close();
    if (maps.length > 0) {
//      print(maps.last);
      var userModel = new UserModel.fromMap(maps.last);
      userCache = userModel;
    }
    return userCache;
  }

  static Future getOnlineUser() async {
    if (userCache != null) {
      return userCache;
    }
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    List<Map> maps = await db.query(UserTalbeName,
        columns: UserTalbeCloum, where: "$ISONLINE = ?", whereArgs: ['1']);
    db.close();
    if (maps.length > 0) {
//      print(maps.last);
      var userModel = new UserModel.fromMap(maps.last);
      return userCache = userModel;
    }

    return null;
  }

  static haveOnlineUser() {
    return userCache != null;
  }

  static getCacheUser() {
    if (userCache != null) {
      return userCache;
    }
  }
}
