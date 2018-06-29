// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Yes No Buttons',
  docs: const [
    MaterialYesNoButtonsComponent,
    MaterialSaveCancelButtonsDirective,
    MaterialSubmitCancelButtonsDirective,
    KeyUpBoundaryDirective,
    EscapeCancelsDirective,
  ],
  demos: const [MaterialYesNoButtonsExample],
  benchmarks: const ['material_yes_no_buttons_init'],
  showGeneratedDocs: true,
)
class MaterialYesNoButtonsGalleryConfig {}

@Component(
  selector: 'material-yes-no-buttons-example',
  directives: const [
    KeyUpBoundaryDirective,
    EscapeCancelsDirective,
    MaterialSaveCancelButtonsDirective,
    MaterialYesNoButtonsComponent,
  ],
  templateUrl: 'material_yes_no_buttons_example.html',
  styleUrls: const ['material_yes_no_buttons_example.scss.css'],
)
class MaterialYesNoButtonsExample {
  void alert(String msg) {
    window.alert(msg);
  }

  bool pending = false;

  void startPendingTimer() {
    pending = true;
    new Future.delayed(const Duration(seconds: 2), () => pending = false);
  }
}
