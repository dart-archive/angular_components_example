// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/reorder_list/reorder_list.dart';

@Component(
  selector: 'reorder-list-demo',
  styleUrls: const ['reorder_list_demo.css'],
  templateUrl: 'reorder_list_demo.html',
  directives: const [
    ReorderListComponent,
    ReorderItemDirective,
    NgFor,
  ],
)
class ReorderListDemoComponent {
  List<String> reorderItems = ["First", "Second", "Third"];

  void onReorder(ReorderEvent reorder) {
    reorderItems.insert(
        reorder.destIndex, reorderItems.removeAt(reorder.sourceIndex));
  }
}
