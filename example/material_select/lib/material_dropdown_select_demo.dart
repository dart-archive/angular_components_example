// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_select/material_select_searchbox.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

import 'material_dropdown_select_demo.template.dart' as demo;

@GallerySectionConfig(displayName: 'Material Dropdown Select', docs: const [
  MaterialDropdownSelectComponent
], demos: const [
  MaterialDropdownSelectDemoComponent,
], benchmarks: const [
  'material_dropdown_select_init',
])
@Component(
  selector: 'material-dropdown-select-demo',
  // popupBindings should ideally be in a top level or root component.
  // In demos, this is the top level/root component.
  providers: popupBindings,
  directives: const [
    materialInputDirectives,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialSelectSearchboxComponent,
    DropdownSelectValueAccessor,
    MultiDropdownSelectValueAccessor,
    NgModel,
    NgIf
  ],
  templateUrl: 'material_dropdown_select_demo.html',
  styleUrls: const ['material_dropdown_select_demo.scss.css'],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialDropdownSelectDemoComponent {
  static const List<Language> _languagesList = const <Language>[
    const Language('en-US', 'US English'),
    const Language('en-UK', 'UK English'),
    const Language('fr-CA', 'Canadian English'),
    const Language('af', 'Afrikaans'),
    const Language('sq', 'Albanian'),
    const Language('ar', 'Arabic'),
    const Language('hy', 'Armenian'),
    const Language('az', 'Azerbaijani'),
    const Language('eu', 'Basque'),
    const Language('be', 'Belarusian'),
    const Language('bn', 'Bengali'),
    const Language('bs', 'Bosnian'),
    const Language('bg', 'Bulgarian'),
    const Language('ca', 'Catalan'),
    const Language('ceb', 'Cebuano'),
    const Language('zh-CN', 'Chichewa'),
    const Language('zh-TW', 'Chinese'),
    const Language('ny', 'Chinese (Simplified)'),
    const Language('zh', 'Chinese (Traditional)'),
    const Language('hr', 'Croatian'),
    const Language('cs', 'Czech'),
    const Language('da', 'Danish'),
    const Language('nl', 'Dutch'),
    const Language('en', 'English'),
    const Language('eo', 'Esperanto'),
    const Language('et', 'Estonian'),
    const Language('tl', 'Filipino'),
    const Language('fi', 'Finnish'),
    const Language('fr', 'French'),
    const Language('gl', 'Galician'),
    const Language('ka', 'Georgian'),
    const Language('de', 'German')
  ];

  static List<OptionGroup<Language>> _languagesGroups = <OptionGroup<Language>>[
    new OptionGroup<Language>.withLabel(const <Language>[
      const Language('en-US', 'US English'),
      const Language('fr-CA', 'Canadian English'),
    ], 'North America'),
    new OptionGroup<Language>.withLabel(const <Language>[
      const Language('ny', 'Chinese (Simplified)'),
      const Language('zh', 'Chinese (Traditional)')
    ], 'Asia'),
    new OptionGroup<Language>.withLabel(const <Language>[
      const Language('en-UK', 'UK English'),
      const Language('de', 'German')
    ], 'Europe'),
    new OptionGroup<Language>.withLabel(
        const <Language>[], 'Antarctica', 'No languages'),
    // This group will not be rendered.
    new OptionGroup<Language>.withLabel(const <Language>[], 'Pangaea')
  ];

  static List<RelativePosition> _popupPositionsAboveInput = const [
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];
  static List<RelativePosition> _popupPositionsBelowInput = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  static ItemRenderer<Language> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  // Specifying an itemRenderer avoids the selected item from knowing how to
  // display itself.
  static ItemRenderer<Language> _itemRenderer =
      newCachingItemRenderer<Language>(
          (language) => "${language.label} (${language.code})");

  bool useFactoryRenderer = false;
  bool useItemRenderer = false;
  bool useLabelFactory = false;
  bool useOptionGroup = false;
  bool withHeaderAndFooter = false;
  bool popupMatchInputWidth = true;
  bool visible = false;
  bool deselectOnActivate = true;
  String deselectLabel = 'None';

  /// Languages to choose from.
  ExampleSelectionOptions<Language> languageListOptions =
      new ExampleSelectionOptions<Language>(_languagesList);

  ExampleSelectionOptions<Language> languageGroupedOptions =
      new ExampleSelectionOptions<Language>.withOptionGroups(_languagesGroups);

  StringSelectionOptions<Language> get languageOptions =>
      useOptionGroup ? languageGroupedOptions : languageListOptions;

  /// Single Selection Model
  final SelectionModel<Language> singleSelectModel =
      new SelectionModel.withList(selectedValues: [_languagesList[1]]);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.length > 0
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Language';

  /// Multi Selection Model
  final SelectionModel<Language> multiSelectModel =
      new SelectionModel<Language>.withList(allowMulti: true);

  final SelectionModel<int> widthSelection = new SelectionModel<int>.withList();
  final SelectionOptions<int> widthOptions =
      new SelectionOptions<int>.fromList([0, 1, 2, 3, 4, 5]);
  String get widthButtonText => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first.toString()
      : '0';

  final SelectionModel<String> popupPositionSelection =
      new SelectionModel<String>.withList();
  final StringSelectionOptions popupPositionOptions =
      new StringSelectionOptions<String>(['Auto', 'Above', 'Below']);
  String get popupPositionButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  final SelectionModel<String> slideSelection =
      new SelectionModel<String>.withList();
  final StringSelectionOptions slideOptions =
      new StringSelectionOptions<String>(['Default', 'x', 'y']);
  String get slideButtonText => slideSelection.selectedValues.isNotEmpty
      ? slideSelection.selectedValues.first
      : 'Default';

  int get width => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first
      : null;

  List<RelativePosition> get preferredPositions {
    switch (popupPositionButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return RelativePosition.overlapAlignments;
  }

  String get slide => slideSelection.selectedValues.isNotEmpty &&
          slideSelection.selectedValues.first != 'Default'
      ? slideSelection.selectedValues.first
      : null;

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;

  /// Currently selected language for the multi selection model
  String get multiSelectedLanguages =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(',');

  ItemRenderer<Language> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

  FactoryRenderer get factoryRenderer =>
      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;

  FactoryRenderer get labelFactory => useLabelFactory
      ? (_) => demo.ExampleLabelRendererComponentNgFactory
      : null;

  /// Label for the button for multi selection.
  String get multiSelectLanguageLabel {
    var selectedValues = multiSelectModel.selectedValues;
    if (selectedValues.isEmpty) {
      return "Select Languages";
    } else if (selectedValues.length == 1) {
      return itemRenderer(selectedValues.first);
    } else {
      return "${itemRenderer(selectedValues.first)} + ${selectedValues
      .length - 1} more";
    }
  }

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      // TODO(google): Avoid using Timer.run.
      Timer.run(() {
        searchbox.focus();
      });
    }
  }

  Language selectionValue;
  List<Language> selectionValues = [];
  String get selectionValuesLabel {
    final size = selectionValues.length;
    if (size == 0) {
      return 'Select Languages';
    } else if (size == 1) {
      return itemRenderer(selectionValues.first);
    } else {
      return "${itemRenderer(selectionValues.first)} + ${size - 1} more";
    }
  }

  String selectionOption;
}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;

  @override
  String toString() => uiDisplayName;
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: const ['material-icon { margin-right: 8px; }'],
  directives: const [MaterialIconComponent],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class ExampleRendererComponent implements RendersValue<Language> {
  String displayName = '';

  @override
  set value(Language newValue) {
    displayName = newValue.uiDisplayName;
  }
}

@Component(
  selector: 'example-label-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: const [
    ':host { margin-left: 16px}'
        'material-icon { margin-right: 8px}',
  ],
  directives: const [MaterialIconComponent],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class ExampleLabelRendererComponent implements RendersValue<OptionGroup> {
  String displayName = '';

  @override
  set value(OptionGroup newValue) {
    displayName = newValue.uiDisplayName ?? 'Languages';
  }
}

/// If the option does not support toString() that shows the label, the
/// toFilterableString parameter must be passed to StringSelectionOptions.
class ExampleSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {
  ExampleSelectionOptions(List<T> options)
      : super(options, toFilterableString: (T option) => option.toString());
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
            toFilterableString: (T option) => option.toString());
  @override
  SelectableOption getSelectable(item) =>
      item is Language && item.code.contains('en')
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}
