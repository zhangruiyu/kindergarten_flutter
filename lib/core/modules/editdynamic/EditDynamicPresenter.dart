import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_multiple/image_picker_multiple.dart';
import 'package:kindergarten/core/modules/editdynamic/DynamicSelectedPicTask.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:tencent_cos/tencent_cos.dart';

const PIC_TYPE = 0;
const VIDEO_TYPE = 1;

class EditDynamicPresenter {
  EditDynamicContract _view;
  Map<String, dynamic> props;
  int dynamicType = PIC_TYPE;
  List<DynamicSelectedPicTask> selectedPics =
      new List<DynamicSelectedPicTask>();

  EditDynamicPresenter(this._view, this.props) {}

  void getImage() async {
    List<dynamic> selectedLocalPics = await MultipleImagePicker
        .pickImage(selectedPics.map((DynamicSelectedPicTask dspk) {
      return dspk.localUrl.toString();
    }).toList());
    _view.refresh(() {
      selectedPics.clear();
      selectedLocalPics.forEach((localUrl) {
        selectedPics.add(new DynamicSelectedPicTask(localUrl, selectedPics));
      });
    });
  }

  void commitPics() {
    successCount = 0;
    RequestHelper.getOCSPeriodEffectiveSignSign(dynamicType).then((data) {
      selectedPics.forEach((DynamicSelectedPicTask selectedPic) {
        selectedPic.upload(data['cosPath'], data['sign']);
        TencentCos.setMethodCallHandler(_handleMessages);
      });
    });
  }

  void commitComment() {
    if (_view.getText()?.isNotEmpty == true) {
      //图片上传完毕 开始把信息给服务端
      RequestHelper
          .commitDynamicPic(_view.getText(), selectedPics)
          .then((onValue) {
        Navigator.pop(_view.gGontext());
      }, onError: (e) {});
    }
  }

  int successCount = 0;

  Future<Null> _handleMessages(MethodCall call) async {
    String localUrl = call.arguments['localUrl'];
    DynamicSelectedPicTask containsSelectedPic =
        selectedPics.singleWhere((DynamicSelectedPicTask selectedPic) {
      return selectedPic.localUrl == localUrl;
    });
    if (containsSelectedPic == null) {
      print('没找到');
      return;
    }
    print(call.method);
    print(call.arguments);
    if (call.method == "onProgress") {
      print(call.arguments['progress'].toInt());
      print('call.arguments[' '] as int');
      print('call.arguments[' '] as int');
      containsSelectedPic.progressImageKey.currentState
          .setProgress((call.arguments['progress'] as double).toInt());
    } else if (call.method == "onSuccess") {
      successCount = successCount + 1;
      String netUrl = call.arguments['url'];
      containsSelectedPic.resourcePath =
          "$netUrl*${containsSelectedPic.sequence}";
      if (successCount == selectedPics.length) {
        commitComment();
      }
    }
  }
}

abstract class EditDynamicContract {
  void refresh(VoidCallback fn);

  String getText();

  BuildContext gGontext();
}
