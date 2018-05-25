import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';

import 'package:kindergarten/core/base/NetException.dart';
import 'package:kindergarten/repository/UserModel.dart';

class RequestClient {
  static Future request(String url,
      [Map<String, dynamic> queryParameters]) async {
    var host = Platform.isAndroid ? '192.168.2.16:8080' : '127.0.0.1:8080';
    var httpClient = new HttpClient();
    UserModel onlineUser = UserProvide.getCacheUser();
    Options options= new Options(
        baseUrl:'http://${Platform.isAndroid ? '192.168.2.16:8080' : '127.0.0.1:8080'}',
        connectTimeout:15000,
        receiveTimeout:13000,
      headers: {'os': Platform.operatingSystem,'token': onlineUser.token}
    );
    Dio dio = new Dio(options);
    String requestUrl = '$url';
    var response = await dio.post(requestUrl,data: new FormData.from(queryParameters),);
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(utf8.decoder).join();
      var data = json.decode(jsonData);
      print(requestUrl);
      print(jsonData);
      if (data['code'].toString() == '1003') {
        UserProvide.loginOut();
        return new Future.value(data["data"]);
      } else if (data['code'].toString() != '200') {
//        ScaffoldState.showSnackBar(new SnackBar(content: new Text(data['msg'])));
        throw new NetException(data['code'], data['msg']);
      } else {
        return new Future.value(data["data"]);
      }
    } else {
      throw 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}
