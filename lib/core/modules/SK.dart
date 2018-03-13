import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/home/account/AccountPage.dart';

class SK {
  //动态列表页state
  static final GlobalKey<RefreshIndicatorState> dynamicRefreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  //账户页面整个state
  static final GlobalKey<AccountPageState> accountPageStateKey =
  new GlobalKey<AccountPageState>();
}
