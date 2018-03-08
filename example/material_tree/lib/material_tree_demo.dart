// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_shared.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

/// The gallery component that combines all the individual demos.
@GallerySectionConfig(displayName: 'Material Tree', docs: const [
  MaterialTreeComponent
], demos: const [
  MaterialTreeFlatReadonlyDemoComponent,
  MaterialTreeFlatSelectableDemoComponent,
  MaterialTreeFlatMultiDemoComponent,
  MaterialTreeNestedSingleDemoComponent,
  MaterialTreeNestedSingleParentSelectableDemoComponent,
  MaterialTreeNestedMultiDemoComponent,
  MaterialTreeNestedItemRenderingComponent,
  MaterialTreeNestedComponentRenderingComponent,
  MaterialTreeNestedExpandDemoComponent,
  MaterialTreeDropdownSingleDemoComponent,
  MaterialTreeDropdownMultiDemoComponent,
  MaterialTreeDropdownFilterableDemoComponent,
  MaterialTreeDropdownNestedFilterableDemoComponent,
  MaterialTreeDropdownNestedFilterInPopupDemoComponent,
  MaterialTreeNestedSingleDividerDemoComponent,
  MaterialTreeViewMoreDemoComponent,
], benchmarks: const [
  'material_tree_100_init',
])
class MaterialTreeCombinedDemoComponent {}
