// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material-list-demo',
  styleUrls: const ['material_list_demo.css'],
  templateUrl: 'material_list_demo.html',
  directives: const [
    CORE_DIRECTIVES,
    GlyphComponent,
    MaterialListComponent,
    MaterialListItemComponent,
  ],
)
class MaterialListDemoComponent {
  List<String> get sizes => const <String>[
        MaterialListSize.auto,
        MaterialListSize.xSmall,
        MaterialListSize.medium,
        MaterialListSize.xLarge
      ];

  SelectionModel<String> colorSelection = new SelectionModel.withList();

  String get selectedColor => colorSelection.selectedValues.isEmpty
      ? 'red'
      : colorSelection.selectedValues.first;

  void selectColor(String color) {
    colorSelection.select(color);
  }
}
