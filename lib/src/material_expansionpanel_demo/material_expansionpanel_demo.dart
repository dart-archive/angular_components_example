// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_set.dart';

@Component(
    selector: 'material-expansionpanel-demo',
    templateUrl: 'material_expansionpanel_demo.html',
    directives: const [
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
    ])
class MaterialExpansionpanelDemoComponent {
  // Nothing here.
}
