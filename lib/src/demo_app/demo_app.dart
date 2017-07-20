// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'demo-app',
  styleUrls: const ['demo_app.css'],
  templateUrl: 'demo_app.html',
  directives: const [MaterialButtonComponent, MaterialCheckboxComponent],
)
class DemoAppComponent {
  bool allowed = true;
  int count = 0;

  void increment() {
    count++;
  }

  void reset() {
    count = 0;
  }
}
