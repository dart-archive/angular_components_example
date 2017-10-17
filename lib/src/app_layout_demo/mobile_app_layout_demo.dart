// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';

@Component(
    selector: 'mobile-app-layout-demo',
    directives: const [
      DeferredContentDirective,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialTemporaryDrawerComponent,
      MaterialToggleComponent,
    ],
    templateUrl: 'mobile_app_layout_demo.html',
    styleUrls: const [
      'app_layout_demo.css',
      'package:angular_components/app_layout/layout.scss.css',
    ])
class MobileAppLayoutDemoComponent {
  bool end = false;
  bool overlay = false;
}
