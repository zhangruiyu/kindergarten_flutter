import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

var httpClient = createHttpClient();

class RequestClient {
  static request(String url, [Map<String, String> queryParameters]) async {
    var host = 'localhost:8080';
    var httpClient = new HttpClient();
    var requestUrl = new Uri.http(host, url, queryParameters);
    var request = await httpClient.postUrl(requestUrl);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      print(requestUrl);
      print(json);
      return new Future.value(data["data"]);
    } else {
      throw 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}
