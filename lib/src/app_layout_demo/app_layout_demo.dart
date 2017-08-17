// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'app-layout-demo',
    directives: const [
      DeferredContentDirective,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialPersistentDrawerDirective,
      MaterialToggleComponent,
      MaterialListComponent,
      MaterialListItemComponent,
    ],
    templateUrl: 'app_layout_demo.html',
    styleUrls: const [
      'app_layout_demo.css',
      'package:angular_components/src/components/app_layout/layout.scss.css',
    ])
class AppLayoutDemoComponent {
  bool end = false;
}
