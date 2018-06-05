import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/modules/editdynamic/DynamicSelectedPicTask.dart';
import 'package:kindergarten/core/modules/editdynamic/EditDynamicPresenter.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
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

class EditDynamicPageState extends BasePageState<EditDynamicPage>
    implements EditDynamicContract {
  EditDynamicPresenter editDynamicPresenter;
  TextEditingController textEditingController = new TextEditingController();

  @override
  initState() {
    editDynamicPresenter = new EditDynamicPresenter(this, widget.props);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //上传图片
//    https://stackoverflow.com/questions/46515679/flutter-firebase-compression-before-upload-image?rq=1

    List<Widget> gridItems = new List<Widget>();

    double itemWidth = WindowUtils.getScreenWidth() / 5.toDouble();
    int dynamicType = editDynamicPresenter.dynamicType;
    List<DynamicSelectedPicTask> selectedPics =
        editDynamicPresenter.selectedPics;
    if (dynamicType == PIC_TYPE) {
      selectedPics.forEach((DynamicSelectedPicTask selectedPic) {
        selectedPic.progressImageKey = new GlobalKey<ProgressImageState>();
        selectedPic.sequence = selectedPics.indexOf(selectedPic);
        Widget item = new Padding(
          padding: const EdgeInsets.all(2.0),
          child: new ProgressImage(
            key: selectedPic.progressImageKey,
            builder: (BuildContext context, Size size) {
              return new Image.file(
                new File(selectedPic.localUrl.toString()),
                fit: BoxFit.fill,
              );
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
          editDynamicPresenter.getImage();
        }));
    return new Scaffold(
        appBar: new AppBar(title: new Text('发布动态'), actions: [
          new IconButton(
            icon: const Icon(Icons.send),
            tooltip: '提交修改',
            onPressed: () async {
              editDynamicPresenter.commitPics();
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
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '请输入内容...',
                    labelText: '园中动态内容',
                  ),
                  maxLines: 8,
                  maxLength: 500,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: new GridView.count(
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    children: gridItems,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void refresh(VoidCallback fn) {
    setState(fn);
  }

  @override
  String getText() {
    return textEditingController.text;
  }

  @override
  BuildContext gGontext() {
    return context;
  }
}
