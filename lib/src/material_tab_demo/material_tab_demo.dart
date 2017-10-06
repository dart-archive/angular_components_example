// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material-tab-demo',
  styleUrls: const ['material_tab_demo.css'],
  templateUrl: 'material_tab_demo.html',
  directives: const [
    DeferredContentDirective,
    MaterialTabComponent,
    MaterialTabPanelComponent,
    NamedContentComponent,
  ],
)
class MaterialTabDemoComponent {
  // Nothing here.
}


/// Simple pass-thru content container which announces its construction and
/// displays a label (in a <p> tag) above the content.
/// Only use this component in demos.
///
/// __Attributes__
/// `name: string` -- Name of component.
@Component(
  selector: 'named-content',
  template: r'''
        <p>{{label}}</p>
        <ng-content></ng-content>''',
)
class NamedContentComponent {
  String get label => '$_componentName Content';
  final String _componentName;
  NamedContentComponent(@Attribute('name') this._componentName) {
    print('Named Component "$_componentName" instantiated');
  }
}
