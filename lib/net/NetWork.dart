import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kindergarten/core/base/NetException.dart';
import 'dart:io' show Platform;

import 'package:kindergarten/repository/UserModel.dart';

var httpClient = createHttpClient();

class RequestClient {
  static Future request(String url,
      [Map<String, String> queryParameters]) async {
    var host = Platform.isAndroid ? '192.168.43.20:8080' : 'localhost:8080';
    var httpClient = new HttpClient();
    var requestUrl = new Uri.http(host, url, queryParameters);
    UserModel onlineUser = UserProvide.getCacheUser();
    var response =
        await httpClient.postUrl(requestUrl).then((HttpClientRequest request) {
      request.headers.add('os', Platform.operatingSystem);
      if (onlineUser != null) {
        request.headers.add('token', onlineUser.token);
      }
      return request.close();
    });
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      print(requestUrl);
      print(json);
      if (data['code'] != '200') {
//        ScaffoldState.showSnackBar(new SnackBar(content: new Text(data['msg'])));
        throw new NetException(data['code'],data['msg'] );
      } else {
        return new Future.value(data["data"]);
      }
    } else {
      throw 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}
