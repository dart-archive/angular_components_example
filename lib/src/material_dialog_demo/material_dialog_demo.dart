// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'material-dialog-demo',
    styleUrls: const ['material_dialog_demo.css'],
    templateUrl: 'material_dialog_demo.html',
    directives: const [
      CORE_DIRECTIVES,
      AutoDismissDirective,
      AutoFocusDirective,
      MaterialButtonComponent,
      MaterialDialogComponent,
      MaterialIconComponent,
      ModalComponent,
    ])
class MaterialDialogDemoComponent {
  bool showBasicDialog = false;
  bool showBasicScrollingDialog = false;
  bool showMaxHeightDialog = false;
  bool showHeaderedDialog = false;
  bool showDialogWithError = false;
  bool showInfoDialog = false;
  bool showAutoDismissDialog = false;
  bool showCustomColorsDialog = false;
  bool showNoHeaderFooterDialog = false;

  final maxHeightDialogLines = <String>[];

  String dialogWithErrorErrorMessage;

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
}
