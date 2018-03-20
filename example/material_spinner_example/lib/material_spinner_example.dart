// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
    displayName: 'Material Spinner',
    docs: const [MaterialSpinnerComponent],
    demos: const [MaterialSpinnerExample],
    benchmarks: const ['material_spinner_init'])
class MaterialSpinnerGalleryConfig {}

@Component(
  selector: 'material-spinner-example',
  directives: const [MaterialSpinnerComponent],
  templateUrl: 'material_spinner_example.html',
  styleUrls: const ['material_spinner_example.scss.css'],
)
class MaterialSpinnerExample {}
