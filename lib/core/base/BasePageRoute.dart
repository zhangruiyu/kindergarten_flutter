import 'package:flutter/material.dart';

abstract class BasePageRoute extends StatefulWidget {
  BasePageRoute(this.props){
    print(props);
  }

  final Map<String, String> props;
}
