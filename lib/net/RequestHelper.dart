import 'package:kindergarten/net/NetWork.dart';

class RequestHelper {
  static login(String tel, String password) {
    return RequestClient
        .request('/public/auth/login', {'tel': tel, 'password': password});
  }

  static verifyIsRegister(String tel) {
    return RequestClient.request('/public/verifyIsRegister', {'tel': tel});
  }
}
