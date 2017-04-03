// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [materialDirectives, defaultPopupSizeProvider],
    providers: const [materialProviders])
class AppComponent {
  int count = 0;

  bool allowed = true;

  // Material Dialog
  bool showBasicDialog = false;
  bool showBasicScrollingDialog = false;
  bool showMaxHeightDialog = false;
  bool showHeaderedDialog = false;
  bool showDialogWithError = false;
  bool showInfoDialog = false;
  bool showAutoDismissDialog = false;
  bool showCustomColorsDialog = false;
  bool showNoHeaderFooterDialog = false;

  // Material Popup
  bool basicPopupVisible = false;
  bool headerFooterPopupVisible = false;
  bool sizePopupVisible = false;

  String get tooltipMsg => 'All the best messages appear in tooltips.';

  String get longString => 'Learn more about web development with AngularDart '
      'here. You will find tutorials to get you started.';

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

  List<String> get sizes =>
      const <String>[
        MaterialListSize.auto,
        MaterialListSize.xSmall,
        MaterialListSize.medium,
        MaterialListSize.xLarge
      ];

  SelectionModel<String> colorSelection = new SelectionModel.withList();

  String get selectedColor =>
      colorSelection.selectedValues.isEmpty
          ? 'red'
          : colorSelection.selectedValues.first;

  void selectColor(String color) {
    colorSelection.select(color);
  }


  // Material Select
  String protocol;

  static const languagesList = const [
    const Language('en-US', 'US English'),
    const Language('en-UK', 'UK English'),
    const Language('fr-CA', 'Canadian French')
  ];

  List<Language> get languages => languagesList;

  final SelectionOptions<Language> languageOptions = new SelectionOptions
      .fromList(languagesList);
  final SelectionModel<Language> targetLanguageSelection = new SelectionModel
      .withList(allowMulti: true);

  static const List<Language> _languagesListLong = const <Language>[
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
  new CachingItemRenderer<Language>(
          (language) => "${language.label} (${language.code})");

  bool useComponentRenderer = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool withHeaderAndFooter = false;
  bool popupMatchInputWidth = true;
  bool visible = false;

  // Languages to choose from.
  ExampleSelectionOptions<Language> languageListOptions =
  new ExampleSelectionOptions<Language>(_languagesListLong);

  ExampleSelectionOptions<Language> languageGroupedOptions =
  new ExampleSelectionOptions<Language>.withOptionGroups(_languagesGroups);

  StringSelectionOptions<Language> get languageOptionsLong =>
      useOptionGroup ? languageGroupedOptions : languageListOptions;

  // Single Selection Model.
  final SelectionModel<Language> singleSelectModel =
  new SelectionModel.withList(selectedValues: [_languagesListLong[1]]);

  // Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.length > 0
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Language';

  // Multi Selection Model.
  final SelectionModel<Language> multiSelectModel =
  new SelectionModel<Language>.withList(allowMulti: true);

  final SelectionModel<int> widthSelection = new SelectionModel<int>.withList();
  final SelectionOptions<int> widthOptions =
  new SelectionOptions<int>.fromList([0, 1, 2, 3, 4, 5]);

  String get widthButtonText =>
      widthSelection.selectedValues.isNotEmpty
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

  String get slideButtonText =>
      slideSelection.selectedValues.isNotEmpty
          ? slideSelection.selectedValues.first
          : 'Default';

  int get width =>
      widthSelection.selectedValues.isNotEmpty
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

  String get slide =>
      slideSelection.selectedValues.isNotEmpty &&
          slideSelection.selectedValues.first != 'Default'
          ? slideSelection.selectedValues.first
          : null;

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;

  // Currently selected language for the multi selection model.
  String get multiSelectedLanguages =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(', ');

  ItemRenderer<Language> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

  ComponentRenderer get componentRenderer =>
      useComponentRenderer ? (_) => ExampleRendererComponent : null;

  // Label for the button for multi selection.
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
    template: '<glyph icon="language"></glyph>{{disPlayName}}',
    styles: const ['glyph { vertical-align: middle; margin-right: 8px; }'],
    directives: const [GlyphComponent])
class ExampleRendererComponent implements RendersValue {
  String disPlayName = '';

  @override
  set value(newValue) {
    disPlayName = (newValue as Language).uiDisplayName;
  }
}

@Injectable()
PopupSizeProvider createPopupSizeProvider() {
  return const PercentagePopupSizeProvider();
}

@Directive(selector: '[defaultPopupSizeProvider]', providers: const [
  const Provider(PopupSizeProvider, useFactory: createPopupSizeProvider)
])
class defaultPopupSizeProvider {}

// If the option does not support toString() that shows the label, the
// toFilterableString parameter must be passed to StringSelectionOptions.
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