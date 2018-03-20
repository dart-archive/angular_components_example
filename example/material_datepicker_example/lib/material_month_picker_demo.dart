// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_month_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';

@Component(
  selector: 'material-month-picker-demo',
  providers: const [datepickerBindings],
  directives: const [DateRangeInputComponent, MaterialMonthPickerComponent],
  templateUrl: 'material_month_picker_demo.html',
  styleUrls: const ['material_month_picker_demo.scss.css'],
)
class MaterialMonthPickerDemoComponent {
  static Date monthsFromNow(int months) => new Date.today().add(months: months);

  DateRange limitToRange = new DateRange(
      new Date.today().add(years: -5), new Date.today().add(years: 5));

  CalendarState plainModel = new CalendarState.selected(
      [new CalendarSelection('default', monthsFromNow(-4), monthsFromNow(4))],
      resolution: CalendarResolution.months);

  CalendarState singleDateModel = new CalendarState.selected(
      [new CalendarSelection('default', monthsFromNow(0), monthsFromNow(0))],
      resolution: CalendarResolution.months);

  CalendarState dateRangeModel = new CalendarState.selected(
      [new CalendarSelection('default', monthsFromNow(-7), monthsFromNow(0))],
      resolution: CalendarResolution.months);
}
