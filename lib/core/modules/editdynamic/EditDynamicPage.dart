import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/constant/Constant.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:kindergarten/net/RequestHelper.dart';
import 'package:http/http.dart' as http;
import 'package:tencent_cos/tencent_cos.dart';
import 'package:image_picker_multiple/image_picker_multiple.dart';
import 'package:progress_image/progress_image.dart';

class EditDynamicPage extends BasePageRoute {
  static const String routeName = '/EditDynamicPage';

  @override
  String getRouteName() {
    return routeName;
  }

  EditDynamicPage([Map<String, dynamic> props]) : super(props);

  @override
  State<StatefulWidget> createState() {
    return new EditDynamicPageState();
  }
}

const PIC_TYPE = 0;
const VIDEO_TYPE = 1;

class EditDynamicPageState extends BasePageState<EditDynamicPage> {
  List<dynamic> selectedPics = new List<dynamic>();
  var informData = [];
  var dynamicType = PIC_TYPE; //0是图片动态 1是视频动态
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 300), () {
      refreshIndicatorKey.currentState?.show();
    });
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    RequestHelper.getInforms(0).then((data) {
      setState(() {
//        localList['dynamics'] = data['dynamics'];
//
//        var allClassRoomUserInfo = data['allClassRoomUserInfo'];
//        if (allClassRoomUserInfo is List && allClassRoomUserInfo.length > 0) {
//          localList['allClassRoomUserInfo'] = data['allClassRoomUserInfo'];
//        }
//        print(localList['allClassRoomUserInfo'].length);
        informData = data;
      });
      completer.complete(null);
    }).catchError((onError) {
      completer.complete(null);
      setState(() {});
    });
    return completer.future;
  }

  void getImage() async {
    selectedPics = await MultipleImagePicker.pickImage(selectedPics);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //上传图片
//    https://stackoverflow.com/questions/46515679/flutter-firebase-compression-before-upload-image?rq=1

    List<Widget> gridItems = new List<Widget>();

    double itemWidth = WindowUtils.getScreenWidth() / 5.toDouble();
    if (dynamicType == PIC_TYPE) {
      selectedPics.forEach((selectedPic) {
        Widget item = new Padding(
          padding: const EdgeInsets.all(2.0),
          child: new ProgressImage(
            builder: (BuildContext context, Size size) {
              return new Image.file(new File(selectedPic.toString()));
            },
            width: itemWidth,
            height: itemWidth,
          ),
        );
        gridItems.add(item);
      });
    }
    gridItems.add(new IconButton(
        icon: new Icon(
          Icons.add_a_photo,
          size: 30.0,
          color: const Color(0x40808080),
        ),
        onPressed: () {
          getImage();
        }));
    return new Scaffold(
        appBar: new AppBar(title: new Text('发布动态'), actions: [
          new IconButton(
            icon: const Icon(Icons.send),
            tooltip: '提交修改',
            onPressed: () async {
//        commitChange();
//              TencentCos.uploadByFile();
              /* RequestHelper.getOCSPeriodEffectiveSignSign(dynamicType).then((data){
                TencentCos.uploadByFile(data['cosPath'],_image.toString(),data['sign']);
              });*/
            },
          )
        ]),
        body: new SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0),
//          constraints: BoxConstraints(minHeight: 120.0),
            child: Column(
              children: <Widget>[
                new TextFormField(
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '请输入内容...',
                    labelText: '园中动态内容',
                  ),
                  maxLines: 8,
                  maxLength: 500,
                ),
                new GridView.count(
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  children: gridItems,
                )
              ],
            ),
          ),
        ));
  }
}
