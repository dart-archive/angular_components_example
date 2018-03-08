// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(displayName: 'Material Icon', docs: const [
  MaterialIconComponent
], demos: const [
  MaterialIconDemoComponent
], benchmarks: const [
  'material_icon_init',
  'material_icon_100_init',
  'material_icon_100_binding_init',
])
class GlyphGalleryConfig {}

@Component(
  selector: 'material-icon-demo',
  directives: const [
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialInputComponent
  ],
  exports: const [done, doneAll, doneOutline],
  templateUrl: 'material_icon_demo.html',
  styleUrls: const ['material_icon_demo.scss.css'],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
  preserveWhitespace: true,
)
class MaterialIconDemoComponent {
  Icon iconModel = done;
  String iconColor = 'blue';
  String iconName = 'alarm';
}

const done = const Icon('done');
const doneAll = const Icon('done_all');
const doneOutline = const Icon('done_outline');
