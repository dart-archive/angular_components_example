// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_auto_suggest_input.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_forms/angular_forms.dart';

import 'material_auto_suggest_input_demo.template.dart' as demo;

List<String> _numberNames = <String>[
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen'
];

ItemRenderer<List<int>> _numberNameRenderer =
    (List<int> list) => list.map((n) => _numberNames[n - 1]).join(', ');

List<OptionGroup<List<int>>> _optionGroups = <OptionGroup<List<int>>>[
  new OptionGroup<List<int>>.withLabel(const <List<int>>[
    const [1, 2, 3, 5],
    const [7],
    const [13],
    const [17]
  ], "Primes less than 20"),
  new OptionGroup<List<int>>.withLabel(const <List<int>>[
    const [2, 4, 6],
    const [8, 10],
    const [12, 14],
    const [16, 18]
  ], "Even less than 20")
];

@Component(
  selector: 'material-auto-suggest-input-demo',
  directives: const [
    formDirectives,
    MaterialAutoSuggestInputComponent,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
  ],
  templateUrl: 'material_auto_suggest_input_demo.html',
  styleUrls: const ['material_auto_suggest_input_demo.css'],
)
class MaterialAutoSuggestInputDemoComponent {
  static final List<RelativePosition> _popupPositionsAboveInput = const [
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];
  static final List<RelativePosition> _popupPositionsBelowInput = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  final SelectionModel<List> singleModel =
      new SelectionModel<List>.withList(allowMulti: false);
  final SelectionModel<List> multiModel =
      new SelectionModel<List>.withList(allowMulti: true);

  final ExampleSelectionOptions suggestionOptions =
      new ExampleSelectionOptions.withOptionGroups(_optionGroups);
  final ExampleSelectionOptions suggestionOptionsWithItemRenderer =
      new ExampleSelectionOptions<List<int>>.withOptionGroups(_optionGroups,
          toFilterableString: _numberNameRenderer);

  final emptySuggestionOptions =
      new StringSelectionOptions<String>(const <String>[]);

  final SelectionModel<String> popupPositionSelection =
      new SelectionModel<String>.withList();
  final StringSelectionOptions popupPositionOptions =
      new StringSelectionOptions<String>(['Auto', 'Above', 'Below']);

  Control formControl = new Control('');
  String inputText = '';

  bool filterSuggestions = true;
  bool popupMatchInputWidth = true;
  bool showClearIcon = false;
  bool hideCheckbox = false;
  bool shouldClearOnSelection = false;
  bool useLabelFactory = false;
  bool useFactoryRenderer = false;
  bool disabled = false;
  String label = 'Search...';
  String emptyPlaceholder = 'No matches';
  String leadingGlyph = 'search';
  int limit = 10;

  String get limitInput => '$limit';
  set limitInput(String val) {
    try {
      limit = int.parse(val);
    } catch (_) {
      limit = 0;
    }
  }

  SelectionOptions get options => suggestionOptionsWithItemRenderer;

  ItemRenderer<List<int>> get itemRenderer => _numberNameRenderer;

  FactoryRenderer get factoryRenderer =>
      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;

  FactoryRenderer get labelFactory => useLabelFactory
      ? (_) => demo.ExampleLabelRendererComponentNgFactory
      : null;

  String get popupPositionSelectButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  List<RelativePosition> get popupPositions {
    switch (popupPositionSelectButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return [];
  }
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <material-icon icon="grade" baseline></material-icon>
        {{displayValue}}
    ''',
  styles: const ['material-icon { margin-right: 8px; }'],
  directives: const [MaterialIconComponent],
  preserveWhitespace: true,
)
class ExampleRendererComponent implements RendersValue {
  String displayValue = '';

  @override
  @Input()
  set value(newValue) {
    displayValue = _numberNameRenderer(newValue);
  }
}

@Component(
  selector: 'example-label-renderer',
  template: r'''
        <span>
          <material-icon icon="language" baseline></material-icon>
          {{displayValue}}
        </span>
    ''',
  styles: const [
    'span { color: #9e9e9e; font-size: 12px;} material-icon {margin: 0 8px;}'
  ],
  directives: const [MaterialIconComponent],
  preserveWhitespace: true,
)
class ExampleLabelRendererComponent implements RendersValue {
  String displayValue = '';

  @override
  @Input()
  set value(newValue) {
    displayValue = newValue.uiDisplayName;
  }
}

class ExampleSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {
  ExampleSelectionOptions(List<T> options) : super(options);
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups,
      {ItemRenderer<T> toFilterableString})
      : super.withOptionGroups(optionGroups,
            toFilterableString: toFilterableString);
  @override
  SelectableOption getSelectable(item) {
    if (item is List && item.contains(13)) {
      return SelectableOption.Disabled;
    }
    return SelectableOption.Selectable;
  }
}
