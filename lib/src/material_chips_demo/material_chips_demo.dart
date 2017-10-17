// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_chips/material_chip.dart';
import 'package:angular_components/material_chips/material_chips.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
  selector: 'material-chips-demo',
  styleUrls: const ['material_chips_demo.css'],
  templateUrl: 'material_chips_demo.html',
  directives: const [
    MaterialChipComponent,
    MaterialChipsComponent,
    MaterialIconComponent
  ],
)
class MaterialChipsDemoComponent {
  final chipText = "My Text";
}
