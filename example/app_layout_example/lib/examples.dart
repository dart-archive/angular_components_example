// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

import 'app_layout_example.dart';
import 'mobile_app_layout_example.dart';

@GallerySectionConfig(displayName: 'App Layout', docs: const [
  MaterialPersistentDrawerDirective,
  MaterialTemporaryDrawerComponent,
], demos: const [
  MaterialDrawerExample,
  MaterialDrawerMobileExample,
], relatedUrls: const {
  'Material Spec (Drawer)':
      'https://material.io/guidelines/patterns/navigation-drawer.html'
      '#navigation-drawer-behavior',
  'Material Spec (App Bar)':
      'https://material.io/guidelines/layout/structure.html#structure-app-bar',
})
class MaterialDrawerExamples {}
