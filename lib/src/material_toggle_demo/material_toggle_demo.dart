// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material-toggle-demo',
  styleUrls: const ['material_toggle_demo.css'],
  templateUrl: 'material_toggle_demo.html',
  directives: const [
    MaterialToggleComponent,
  ],
)
class MaterialToggleDemoComponent {
  bool btEnabled = false;
  bool deviceVisible = false;

  bool basicState = null;

  String get btnToggleLabel =>
      'Tap to turn Bluetooth ${btEnabled ? 'OFF' : 'ON'}.';
}
