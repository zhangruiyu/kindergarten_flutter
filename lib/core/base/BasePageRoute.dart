import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class KGPAGERoute<T> extends MaterialPageRoute<T> {
  KGPAGERoute({@required Widget widget, @required String name})
      : super(
            builder: (BuildContext context) {
              return widget;
            },
            settings: RouteSettings(name: name));
}

abstract class RouteAttribute<F> {
  String getRouteName();
}

//F为返回值类型
abstract class BasePageRoute<F> extends StatefulWidget
    implements RouteAttribute {
  BasePageRoute(this.props, {Key key}) : super(key: key);

  final Map<String, dynamic> props;

  KGPAGERoute<F> route() {
    return new KGPAGERoute<F>(widget: this, name: getRouteName());
  }
}

abstract class BasePageLessRoute<F> extends StatelessWidget
    implements RouteAttribute {
  BasePageLessRoute(this.props);

  final Map<String, dynamic> props;

  KGPAGERoute<F> toRoute() {
    return new KGPAGERoute<F>(widget: this, name: getRouteName());
  }
}
