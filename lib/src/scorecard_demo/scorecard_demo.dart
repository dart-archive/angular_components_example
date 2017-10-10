// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/scorecard/scoreboard.dart';
import 'package:angular_components/scorecard/scorecard.dart';

@Component(
  selector: 'scorecard-demo',
  templateUrl: 'scorecard_demo.html',
  directives: const [
    ScoreboardComponent,
    ScorecardComponent,
  ],
)
class ScorecardDemoComponent {
  // Nothing here.
}
