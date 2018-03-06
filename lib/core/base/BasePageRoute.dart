import 'package:flutter/material.dart';

abstract class BasePageRoute extends StatefulWidget {
  BasePageRoute(this.props);

  final Map<String, dynamic> props;
}

abstract class BasePageLessRoute extends StatelessWidget {
  BasePageLessRoute(this.props);

  final Map<String, dynamic> props;
}
