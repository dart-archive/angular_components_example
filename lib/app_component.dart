// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/demo_app/demo_app.dart';
import 'src/material_button_demo/material_button_demo.dart';
import 'src/material_checkbox_demo/material_checkbox_demo.dart';
import 'src/material_chips_demo/material_chips_demo.dart';
import 'src/material_dialog_demo/material_dialog_demo.dart';
import 'src/material_expansionpanel_demo/material_expansionpanel_demo.dart';
import 'src/material_icon_demo/material_icon_demo.dart';
import 'src/material_input_demo/material_input_demo.dart';
import 'src/material_list_demo/material_list_demo.dart';
import 'src/material_popup_demo/material_popup_demo.dart';
import 'src/material_progress_demo/material_progress_demo.dart';
import 'src/material_radio_demo/material_radio_demo.dart';
import 'src/material_select_demo/material_select_demo.dart';
import 'src/material_spinner_demo/material_spinner_demo.dart';
import 'src/material_tab_demo/material_tab_demo.dart';
import 'src/material_toggle_demo/material_toggle_demo.dart';
import 'src/material_tooltip_demo/material_tooltip_demo.dart';
import 'src/material_tree_demo/material_tree_demo.dart';
import 'src/material_yes_no_buttons_demo/material_yes_no_buttons_demo.dart';
import 'src/reorder_list_demo/reorder_list_demo.dart';
import 'src/scorecard_demo/scorecard_demo.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [
    DemoAppComponent,
    MaterialButtonDemoComponent,
    MaterialCheckboxDemoComponent,
    MaterialChipsDemoComponent,
    MaterialDialogDemoComponent,
    MaterialExpansionpanelDemoComponent,
    MaterialIconDemoComponent,
    MaterialInputDemoComponent,
    MaterialListDemoComponent,
    MaterialPopupDemoComponent,
    MaterialProgressDemoComponent,
    MaterialRadioDemoComponent,
    MaterialSelectDemoComponent,
    MaterialSpinnerDemoComponent,
    MaterialTabDemoComponent,
    MaterialToggleDemoComponent,
    MaterialTooltipDemoComponent,
    MaterialTreeDemoComponent,
    MaterialYesNoButtonsDemoComponent,
    ReorderListDemoComponent,
    ScorecardDemoComponent,
  ],
  providers: const [
    popupBindings,
  ],
)
class AppComponent {
  // Nothing here.
}
