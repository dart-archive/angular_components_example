// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';

export 'path_utils.dart';

/// Returns the name of a class declaration.
String className(ClassDeclaration classDecl) => classDecl.name.name;

/// Parses [source] and visits with [visitor].
///
/// Use this function over `parseCompilationUnit` to print a more helpful
/// message on errors.
///
/// * [path] is only used for reporting errors.
/// * [parseFunctionBodies] is false by default, the opposite behavior of
///   `parseCompilationUnit`.
visitCompilationUnit(String source, RecursiveAstVisitor visitor,
    {String path: 'file', bool parseFunctionBodies: false}) {
  if (source == null)
    throw new ArgumentError('Cannot parse null source for path "$path".');
  try {
    parseCompilationUnit(source, parseFunctionBodies: parseFunctionBodies)
        .accept(visitor);
  } on AnalyzerErrorGroup {
    print('Exception(s) parsing $path.');
    rethrow;
  }
  return visitor;
}
