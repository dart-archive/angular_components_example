// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';

@Component(
  selector: 'date-range-input-demo',
  template: '''
<h2>date-range-input</h2>
It's two date-inputs glued together.
<br>
<date-range-input [(range)]="range"></date-range-input>
<br>
Selected range: {{range}}
''',
  styles: const ['date-range-input { width: 400px; }'],
  directives: const [DateRangeInputComponent],
  providers: const [datepickerBindings],
)
class DateRangeInputDemoComponent {
  DateRange range =
      new DateRange(new Date.today().add(days: -7), new Date.today());
}
