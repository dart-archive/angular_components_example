// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [materialDirectives],
    providers: const [materialProviders])
class AppComponent {
  int count = 0;

  bool allowed = true;
  bool showBasicDialog = false;
  bool showBasicScrollingDialog = false;
  bool showMaxHeightDialog = false;
  bool showHeaderedDialog = false;
  bool showDialogWithError = false;
  bool showInfoDialog = false;
  bool showAutoDismissDialog = false;
  bool showCustomColorsDialog = false;
  bool showNoHeaderFooterDialog = false;

  String dialogWithErrorErrorMessage;

  final maxHeightDialogLines = <String>[];

  void addMaxHeightDialogLine() {
    maxHeightDialogLines.add('This is some text!');
  }

  void removeMaxHeightDialogLine() {
    maxHeightDialogLines.removeLast();
  }

  void toggleErrorMessage() {
    if (dialogWithErrorErrorMessage == null) {
      dialogWithErrorErrorMessage = 'Error message.';
    } else {
      dialogWithErrorErrorMessage = null;
    }
  }

  List<String> reorderItems = ["First", "Second", "Third"];

  void increment() {
    count++;
  }

  void onReorder(ReorderEvent reorder) {
    reorderItems.insert(
        reorder.destIndex, reorderItems.removeAt(reorder.sourceIndex));
  }

  void reset() {
    count = 0;
  }
}
