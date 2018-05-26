import 'package:flutter/material.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/home/home.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  sp = await SharedPreferences.getInstance();
  UserProvide.loadData();
  runApp(new KindergartenApp());
}
