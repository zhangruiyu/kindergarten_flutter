import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';
import 'package:kindergarten/core/base/BasePageState.dart';
import 'package:kindergarten/core/utils/WindowUtils.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ReviewPicPage extends BasePageRoute {
  static const String routeName = '/ReviewPicPage';

  @override
  String getRouteName() {
    return routeName;
  }

  ReviewPicPage([Map<String, dynamic> props]) : super(props);

  static start(context, props) {
    Navigator.of(context).push(new ReviewPicPage(props).route());
  }

  @override
  State<StatefulWidget> createState() {
    return new ReviewPicPageState();
  }
}

class ReviewPicPageState extends BasePageState<ReviewPicPage> {
  PageController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =
        new PageController(initialPage: widget.props['pisition']);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('预览'),
        ),
        body: new PageView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.props['itemPics'].length,
//          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var singleData = widget.props['itemPics'][index];

            return new Container(
              width: WindowUtils.getScreenWidth(),
              child: new ZoomableImage(
                new CachedNetworkImageProvider(
                  singleData,
                ),
                scale: 3.0,
              ),
            );
          },
        ));
  }
}
