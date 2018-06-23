import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:kindergarten/core/base/NetException.dart';
import 'package:kindergarten/repository/UserModel.dart';

class RequestClient {
  static Future request(String url,
      [Map<String, dynamic> queryParameters]) async {
    Options options = new Options(
        baseUrl: 'http://${Platform.isAndroid
            ? '192.168.43.148:8080'
            : '127.0.0.1:8080'}',
        connectTimeout: 15000,
        receiveTimeout: 13000,
        headers: {
          'os': Platform.operatingSystem,
          'token': UserHelper.getUserToken()
        });

    Dio dio = new Dio(options);
    String requestUrl = '$url';
    Response response = await dio.post(
      requestUrl,
      data: new FormData.from(queryParameters ?? new Map<String, String>()),
    );
    if (response.statusCode == HttpStatus.OK) {
      var data = response.data;
      print(options.headers);
      print(requestUrl);
      print(response.data);
      if (data['code'].toString() == '1003') {
        UserHelper.loginOut();
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
