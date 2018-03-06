import 'package:flutter/material.dart';
import 'package:kindergarten/core/base/BasePageRoute.dart';

abstract class BasePageState<T extends BasePageRoute> extends State<T> {
  BasePageState([this.props]);

  final Map<String, String> props;
}
