// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_auto_dismiss.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_set.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(displayName: 'Material ExpansionPanel', docs: const [
  MaterialExpansionPanel,
  MaterialExpansionPanelSet,
  MaterialExpansionPanelAutoDismiss,
], demos: const [
  MaterialExpansionDemo
], benchmarks: const [
  'material_expansionpanel_init',
  'material_expansionpanel_set_init',
])
class MaterialExpansionPanelGalleryConfig {}

@Component(
  selector: 'material-expansion-demo',
  providers: const [overlayBindings],
  directives: const [
    AutoFocusDirective,
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelAutoDismiss,
    MaterialExpansionPanelSet,
    MaterialDialogComponent,
    MaterialInputComponent,
    materialInputDirectives,
    MaterialYesNoButtonsComponent,
    ModalComponent,
    NgModel,
  ],
  styleUrls: const ['material_expansionpanel_example.scss.css'],
  templateUrl: 'material_expansionpanel_example.html',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialExpansionDemo {
  String name = 'Test';
  bool isCustomToolBeltPanelExpanded = true;

  bool showConfirmation = false;
  Completer<bool> dialogFutureCompleter;

  void showConfirmationDialog(AsyncAction event) {
    showConfirmation = true;
    dialogFutureCompleter = new Completer();
    event.cancelIf(dialogFutureCompleter.future);
  }

  void closeDialog(bool proceed) {
    showConfirmation = false;
    if (dialogFutureCompleter != null) {
      dialogFutureCompleter.complete(!proceed);
    }
  }
}
