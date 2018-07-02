// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_chips/material_chip.dart';
import 'package:angular_components/material_chips/material_chips.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Chips',
  docs: const [
    MaterialChipsComponent,
    MaterialChipComponent,
  ],
  demos: const [MaterialChipsDemoComponent],
  benchmarks: const ['material_chips_init'],
  showGeneratedDocs: true,
)
class MaterialChipsExamples {}

@Component(
  selector: 'material-chips-demo',
  templateUrl: 'material_chips_demo.html',
  styleUrls: const ['material_chips_demo.scss.css'],
  directives: const [
    ButtonDirective,
    displayNameRendererDirective,
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
    MaterialIconComponent,
    NgFor
  ],
)
class MaterialChipsDemoComponent {
  String chipText = 'My Text';
  bool enabled = true;

  String get enableText => enabled ? 'disable' : 'enable';

  final chips = <Chip>[];
  final movies = <StarWarsMovie>[];
  MaterialChipsDemoComponent() {
    resetChips();
    resetMovies();
  }

  static const _subjectChips = const [
    const Chip('science'),
    const Chip('math'),
    const Chip('wizardry'),
    const Chip('technology'),
    const Chip('engineering')
  ];

  void resetChips() {
    chips.clear();
    chips.addAll(_subjectChips);
  }

  SelectionModel<HasUIDisplayName> selection = _createSelectionModel();
  static SelectionModel<HasUIDisplayName> _createSelectionModel() =>
      new SelectionModel.multi(selectedValues: [
        new Chip('pepperoni'),
        new Chip('pineapple'),
        new Chip('peppers'),
        new Chip('sausage'),
        new Chip('BACON')
      ]);

  void resetSelection() {
    selection = _createSelectionModel();
  }

  static const _starWarsEpisodes = const [
    const StarWarsMovie('The Phantom Menace', 1),
    const StarWarsMovie('Attack of the Clones', 2),
    const StarWarsMovie('Revenge of the Sith', 3),
    const StarWarsMovie('A New Hope', 4),
    const StarWarsMovie('The Empire Strikes Back', 5),
    const StarWarsMovie('Return of the Jedi', 6),
    const StarWarsMovie('The Force Awakens', 7),
  ];

  void resetMovies() {
    movies.clear();
    movies.addAll(_starWarsEpisodes);
  }

  // Cheap function to convert int (from 0 to 8) to a Roman numeral.
  static String arabicToRoman(int number) {
    if (number == 0) return '';
    if (number >= 5) return 'V${arabicToRoman(number-5)}';
    if (number == 4) return 'IV';
    return 'I${arabicToRoman(number-1)}';
  }

  // TODO(google) Change dynamic to StarWarsMovie once Angular can retain the
  // type information. https://github.com/dart-lang/angular/issues/68
  ItemRenderer<dynamic /*StarWarsMovie*/ > renderMovieChip =
      (dynamic /*StarWarsMovie*/ protoChip) {
    return 'Star Wars: Episode ${arabicToRoman(protoChip.episodeIndex)}'
        ' ${protoChip.title}'
        .toUpperCase();
  };

  void onClick(StarWarsMovie m) {
    print(renderMovieChip(m));
  }
}

class Chip implements HasUIDisplayName {
  @override
  final String uiDisplayName;
  const Chip(this.uiDisplayName);
}

/// An object, for the purpose of this demo, whose definition is beyond our
/// control. You know, like its owners keep changing the thing that we love for
/// no good reason...
class StarWarsMovie {
  final int episodeIndex;
  final String title;
  const StarWarsMovie(this.title, this.episodeIndex);
}
