import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';

class LifecycleInterface {}

LifecycleInterface lifecycleInterface = new LifecycleInterface();
LinkedHashMap<String, Widget> allPageInstance =
    new LinkedHashMap<String, Widget>();

abstract class BasePageState<T extends BasePageRoute> extends State<T>
    with WidgetsBindingObserver {
  BasePageState([this.props]);

  final Map<String, dynamic> props;

  @override
  void dispose() {
    super.dispose();
    print('BasePageState===$this');
    //执行关闭页面回调
    if (props != null && props.containsKey('cbk')) {
      props['cbk']();
    }
  }
}
