// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
    selector: 'material-dialog-demo',
    styleUrls: const ['material_dialog_demo.css'],
    templateUrl: 'material_dialog_demo.html',
    directives: const [
      AutoDismissDirective,
      AutoFocusDirective,
      MaterialButtonComponent,
      MaterialDialogComponent,
      MaterialIconComponent,
      ModalComponent,
      NgFor,
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
