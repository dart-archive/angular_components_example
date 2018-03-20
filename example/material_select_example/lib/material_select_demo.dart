// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';

@Component(
  selector: 'material-select-demo',
  directives: const [
    displayNameRendererDirective,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    NgFor,
  ],
  templateUrl: 'material_select_demo.html',
  styleUrls: const ['material_select_demo.scss.css'],
)
class MaterialSelectDemoComponent {
  final SelectionModel<String> defaultLanguageSelection =
      new SelectionModel.withList();

  final SelectionModel<Language> targetLanguageSelection =
      new SelectionModel.withList(allowMulti: true);

  String proto;
  static const languagesList = const [
    const Language('en-US', 'US English'),
    const Language('en-UK', 'UK English'),
    const Language('fr-CA', 'Canadian French')
  ];

  List<Language> get languages => languagesList;

  final SelectionOptions<Language> languageOptions =
      new SelectionOptions.fromList(languagesList);
}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;
}
