import 'package:flutter/material.dart';

abstract class BasePropsWidget extends StatefulWidget {
  BasePropsWidget(this.props);

  final Map<String, dynamic> props;
}

