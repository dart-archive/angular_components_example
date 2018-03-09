// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';

@Component(
  selector: 'material-input-number-value-accessor-demo',
  directives: const [
    formDirectives,
    FourDecimalsNumberFormat,
    MaterialFabComponent,
    materialNumberInputDirectives,
  ],
  templateUrl: 'material_input_number_value_accessor_demo.html',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
  preserveWhitespace: true,
)
class MaterialInputNumberValueAccessorDemoComponent {
  num value = 123;
  Control form;
  num decimalValue = 123.45678;

  MaterialInputNumberValueAccessorDemoComponent() {
    form = new Control(321, (c) {
      if (c.value == null) return null; // Handled by number accessor
      return c.value > 1000 ? {'TooLargeKey': 'Too large'} : null;
    });
  }

  void increaseValue() {
    value += 1;
  }

  void increaseFormValue() {
    form.updateValue(form.value + 2);
  }
}

NumberFormat createNumberFormat() =>
    new NumberFormat.decimalPattern()..maximumFractionDigits = 4;

@Directive(
  selector: '[fourDecimals]',
  providers: const [
    const Provider(NumberFormat, useFactory: createNumberFormat)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class FourDecimalsNumberFormat {}
