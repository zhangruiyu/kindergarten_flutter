import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/modules/home/home.dart';
import 'package:kindergarten/repository/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  sp = await SharedPreferences.getInstance();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'kindergarten',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:737671692574:ios:248dd05a6518ccc4'
          : '1:737671692574:android:2b656dc48005b0cd',
      gcmSenderID: '737671692574',
      apiKey: 'AIzaSyB0b008LshVI6hK53LeiELiOL3At1j9BQA',
      projectID: 'kindergarten-92c04',
    ),
  );
  storage = new FirebaseStorage(
      app: app, storageBucket: 'gs://kindergarten-92c04.appspot.com/');
  UserProvide.loadData();
  runApp(new KindergartenApp());
}
