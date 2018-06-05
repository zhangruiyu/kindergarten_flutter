import 'package:flutter/material.dart';
import 'package:progress_image/progress_image.dart';
import 'package:tencent_cos/tencent_cos.dart';

class DynamicSelectedPicTask {
  String localUrl;
  //上传到服务器的 包含排序
  String resourcePath;
  List<DynamicSelectedPicTask> selectedPics;

  GlobalKey<ProgressImageState> progressImageKey;

  int sequence;

  DynamicSelectedPicTask(this.localUrl, this.selectedPics);

  void upload(cosPath, sign) {
    TencentCos.uploadByFile(cosPath, localUrl.toString(), sign);
  }
}
