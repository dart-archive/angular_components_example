// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/laminate/overlay/zindexer.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(displayName: 'Material Popup', docs: const [
  MaterialPopupComponent
], demos: const [
  MaterialPopupExample
], benchmarks: const [
  'material_popup_init',
  'material_popup_content_init',
  'material_popup_deferred_content_init',
])
class MaterialPopupDemoComponent {}

@Component(
  selector: 'material-popup-example',
  providers: const [
    popupBindings,
    const Provider(ZIndexer, useClass: ZIndexer)
  ],
  directives: const [
    DefaultPopupSizeProvider,
    DeferredContentDirective,
    DontUseRepositionLoopProvider,
    MaterialButtonComponent,
    MaterialDropdownSelectComponent,
    MaterialPopupComponent,
    MaterialTooltipDirective,
    PopupSourceDirective,
  ],
  templateUrl: 'material_popup_example.html',
  styleUrls: const ['material_popup_example.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialPopupExample {
  // Keep track of each popup's visibility separately.
  final visible = new List.filled(11, false);

  SelectionModel<RelativePosition> position =
      new RadioGroupSingleSelectionModel(RelativePosition.OffsetBottomRight);

  RelativePosition get popupPosition => position.selectedValues.first;

  final SelectionOptions<RelativePosition> positions =
      new SelectionOptions.fromList(positionMap.keys.toList());

  ItemRenderer<RelativePosition> positionLabel =
      (RelativePosition position) => positionMap[position];

  String get ddLabel => positionLabel(popupPosition);
}

final positionMap = <RelativePosition, String>{
  RelativePosition.OffsetBottomRight: 'OffsetBottomRight',
  RelativePosition.OffsetBottomLeft: 'OffsetBottomLeft',
  RelativePosition.OffsetTopRight: 'OffsetTopRight',
  RelativePosition.OffsetTopLeft: 'OffsetTopLeft',
  RelativePosition.InlineBottom: 'InlineBottom',
  RelativePosition.InlineBottomLeft: 'InlineBottomLeft',
  RelativePosition.InlineTop: 'InlineTop',
  RelativePosition.InlineTopLeft: 'InlineTopLeft',

  // cardinal directions
  RelativePosition.AdjacentTop: 'AdjacentTop',
  RelativePosition.AdjacentRight: 'AdjacentRight',
  RelativePosition.AdjacentLeft: 'AdjacentLeft',
  RelativePosition.AdjacentBottom: 'AdjacentBottom',
  // non-corners
  RelativePosition.AdjacentTopLeft: 'AdjacentTopLeft',
  RelativePosition.AdjacentTopRight: 'AdjacentTopRight',
  RelativePosition.AdjacentRightTop: 'AdjacentRightTop',
  RelativePosition.AdjacentRightBottom: 'AdjacentRightBottom',
  RelativePosition.AdjacentBottomRight: 'AdjacentBottomRight',
  RelativePosition.AdjacentBottomLeft: 'AdjacentBottomLeft',
  RelativePosition.AdjacentLeftBottom: 'AdjacentLeftBottom',
  RelativePosition.AdjacentLeftTop: 'AdjacentLeftTop',
};

@Injectable()
PopupSizeProvider createPopupSizeProvider() {
  return new PercentagePopupSizeProvider();
}

@Directive(
  selector: '[defaultPopupSizeProvider]',
  providers: const [
    const Provider(PopupSizeProvider, useFactory: createPopupSizeProvider)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class DefaultPopupSizeProvider {}

@Directive(
  selector: '[dontUseRepositionLoop]',
  providers: const [
    popupBindings,
    const Provider(overlayRepositionLoop, useValue: false),
  ],
)
class DontUseRepositionLoopProvider {}
