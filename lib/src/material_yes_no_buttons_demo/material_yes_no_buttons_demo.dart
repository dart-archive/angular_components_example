// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';

@Component(
  selector: 'material-yes-no-buttons-demo',
  styleUrls: const ['material_yes_no_buttons_demo.css'],
  templateUrl: 'material_yes_no_buttons_demo.html',
  directives: const [
    MaterialYesNoButtonsComponent,
    MaterialSaveCancelButtonsDirective,
  ],
)
class MaterialYesNoButtonsDemoComponent {
  // Nothing here.
}
