import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/home/home.dart';
import 'package:kindergarten/repository/UserModel.dart';

void main() {
  UserProvide.initOnlineUser().then((onlineUser) {
    runApp(new KindergartenApp());
  });
}
