// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material_icon-demo',
  styleUrls: const ['material_icon_demo.css'],
  templateUrl: 'material_icon_demo.html',
  directives: const [
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialInputComponent,
  ],
  exports: const [done, doneAll, doneOutline],
)
class MaterialIconDemoComponent {
  var iconModel = done;
  var iconColor = 'blue';
  var iconName = 'alarm';
}

const done = const Icon('done');
const doneAll = const Icon('done_all');
const doneOutline = const Icon('done_outline');
