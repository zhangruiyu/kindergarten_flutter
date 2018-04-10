// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/album/AlbumPage.dart';
import 'package:kindergarten/core/modules/auth/LoginPage.dart';
import 'package:kindergarten/core/modules/cameralist/CameraListPage.dart';
import 'package:kindergarten/core/modules/inform/InformPage.dart';
import 'package:kindergarten/core/modules/schoolmessage/SchoolMessagePage.dart';
import 'package:kindergarten/core/modules/setting/SettingPage.dart';

typedef Widget GalleryDemoBuilder();

class GalleryItem {
  const GalleryItem({
    @required this.routeName,
    @required this.buildRoute,
  })
      : assert(routeName != null),
        assert(buildRoute != null);

  final String routeName;
  final Widget buildRoute;
}

List<GalleryItem> _buildGalleryItems() {
  // When editing this list, make sure you keep it in sync with
  // the list in ../../test_driver/transitions_perf_test.dart
  final List<GalleryItem> galleryItems = <GalleryItem>[
    // Demos
    new GalleryItem(
      routeName: LoginPage.routeName,
      buildRoute: new LoginPage(),
    ),
    new GalleryItem(
      routeName: InformPage.routeName,
      buildRoute: new InformPage(),
    ),
    new GalleryItem(
      routeName: SchoolMessagePage.routeName,
      buildRoute: new SchoolMessagePage(),
    ),
    new GalleryItem(
      routeName: CameraListPage.routeName,
      buildRoute: new CameraListPage(),
    ),
    new GalleryItem(
      routeName: SettingPage.routeName,
      buildRoute: new SettingPage(),
    ), new GalleryItem(
      routeName: AlbumPage.routeName,
      buildRoute: new AlbumPage(),
    ),
  ];

  // Keep Pesto around for its regression test value. It is not included
  // in (release builds) the performance tests.

  return galleryItems;
}

final List<GalleryItem> kAllGalleryItems = _buildGalleryItems();
