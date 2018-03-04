// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten/core/modules/auth/LoginPage.dart';


typedef Widget GalleryDemoBuilder();

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    @required this.title,
    this.subtitle,
    @required this.category,
    @required this.routeName,
    @required this.buildRoute,
  }) : assert(title != null),
        assert(category != null),
        assert(routeName != null),
        assert(buildRoute != null);

  final String title;
  final String subtitle;
  final String category;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(title),
        subtitle: new Text(subtitle),
        onTap: () {
          if (routeName != null) {
            Timeline.instantSync('Start Transition', arguments: <String, String>{
              'from': '/',
              'to': routeName
            });
            Navigator.pushNamed(context, routeName);
          }
        }
    );
  }
}

List<GalleryItem> _buildGalleryItems() {
  // When editing this list, make sure you keep it in sync with
  // the list in ../../test_driver/transitions_perf_test.dart
  final List<GalleryItem> galleryItems = <GalleryItem>[
    // Demos
    new GalleryItem(
      title: 'Shrine',
      subtitle: 'Basic shopping app',
      category: 'Demos',
      routeName: LoginPage.routeName,
      buildRoute: (BuildContext context) => new LoginPage(),
    ),
  ];

  // Keep Pesto around for its regression test value. It is not included
  // in (release builds) the performance tests.

  return galleryItems;
}

final List<GalleryItem> kAllGalleryItems = _buildGalleryItems();
