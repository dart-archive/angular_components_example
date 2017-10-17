// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';

@Component(
  selector: 'material-list-demo',
  styleUrls: const ['material_list_demo.css'],
  templateUrl: 'material_list_demo.html',
  directives: const [
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    NgFor,
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
