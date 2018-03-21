import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SnackBarUtils {
  static void showSnackBar(ScaffoldState scaffoldState, String text,
      [bool isSuccess = true]) {
    scaffoldState.showSnackBar(new SnackBar(
        content: new Text(text),
        backgroundColor: isSuccess ? Theme
            .of(scaffoldState.context)
            .accentColor : Theme
            .of(scaffoldState.context)
            .errorColor));
  }

}
