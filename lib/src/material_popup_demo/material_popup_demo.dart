// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'material-popup-demo',
  styleUrls: const ['material_popup_demo.css'],
  templateUrl: 'material_popup_demo.html',
  directives: const [
    MaterialButtonComponent,
    MaterialPopupComponent,
    PopupSourceDirective,
    DefaultPopupSizeProvider,
  ],
  providers: const [
    popupBindings,
    DefaultPopupSizeProvider,
  ],
)
class MaterialPopupDemoComponent {
  bool basicPopupVisible = false;
  bool headerFooterPopupVisible = false;
  bool sizePopupVisible = false;

  String get tooltipMsg => 'All the best messages appear in tooltips.';

  String get longString => 'Learn more about web development with AngularDart '
      'here. You will find tutorials to get you started.';
}

@Injectable()
PopupSizeProvider createPopupSizeProvider() {
  return const PercentagePopupSizeProvider();
}

@Directive(selector: '[defaultPopupSizeProvider]', providers: const [
  const Provider(PopupSizeProvider, useFactory: createPopupSizeProvider)
])
class DefaultPopupSizeProvider {}
