import 'dart:async';

import 'package:kindergarten/net/NetWork.dart';

const USER_URL = "/user/normal";
const TEACHER_URL = "/user/teacher";

class RequestHelper {
  static login(String tel, String password) {
    return RequestClient
        .request('/public/auth/login', {'tel': tel, 'password': password});
  }

  static verifyIsRegister(String tel) {
    return RequestClient.request('/public/verifyIsRegister', {'tel': tel});
  }

  static Future getAccountProfile() {
    return RequestClient.request("$USER_URL/profile");
  }

  static Future getDynamics(int page_index) {
    return RequestClient.request("$USER_URL/dynamic/list",{'page_index':page_index.toString()});
  }
}
