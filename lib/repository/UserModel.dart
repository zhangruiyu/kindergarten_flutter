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
final String NAME = "name";
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

final String userTableSql = '''
              CREATE TABLE $UserTalbeName (
                        tel        VARCHAR PRIMARY KEY,
                        name       VARCHAR,
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

  String name;

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
      this.name,
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
    name = map[NAME];
    isOnline = map[ISONLINE];
  }

  Map toMap() {
    Map map = {};
    if (tel != null) {
      map[TEL] = tel;
    }
    if (name != null) {
      map[NAME] = name;
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
  static Future<UserModel> insert(UserModel todo) async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    var code = await db.insert(UserTalbeName, todo.toMap());
    db.close();
    return todo;
  }

  static Future<UserModel> getOnlineUser() async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    List<Map> maps = await db.query(UserTalbeName,
        columns: [TEL, NAME, ISONLINE],
        where: "$TEL = ?",
        whereArgs: ['15201231806']);
    db.close();
    if (maps.length > 0) {
      return new UserModel.fromMap(maps.first);
    }

    return null;
  }
}
