// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/material_calendar_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'material-calendar-picker-demo',
  directives: const [MaterialCalendarPickerComponent],
  providers: const [windowBindings, datepickerBindings],
  templateUrl: 'material_calendar_picker_demo.html',
  styleUrls: const ['material_calendar_picker_demo.scss.css'],
)
class MaterialCalendarPickerDemoComponent {
  static Date date(int days) => new Date.today().add(days: days);

  CalendarState plainModel = new CalendarState.selected(
      [new CalendarSelection('range', date(-4), date(4))]);

  CalendarState colorfulModel = new CalendarState.selected([
    new CalendarSelection('range', date(4), date(8)),
    new CalendarSelection('comparison', date(-1), date(3))
  ]);

  CalendarState overlapModel = new CalendarState.selected([
    new CalendarSelection('range', date(-1), date(8)),
    new CalendarSelection('comparison', date(-5), date(3))
  ]);

  CalendarState mutableModel = new CalendarState.selected(
      [new CalendarSelection('range', date(0), date(4))]);

  void creepForward() {
    var current = mutableModel.selection('range');
    mutableModel = mutableModel.setSelection(new CalendarSelection(
        'range', current.start.add(days: 1), current.end.add(days: 1)));
  }

  CalendarState singleDateModel = new CalendarState.selected(
      [new CalendarSelection('range', date(0), date(0))]);

  CalendarState dateRangeModel = new CalendarState.selected(
      [new CalendarSelection('range', date(-7), date(0))]);
}
