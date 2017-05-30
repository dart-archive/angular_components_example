// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material-radio-demo',
  templateUrl: 'material_radio_demo.html',
  directives: const [
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
  ],
)
class MaterialRadioDemoComponent {
  // Nothing here.
}
