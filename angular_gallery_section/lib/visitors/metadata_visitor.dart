// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';

/// An abstract AstVisitor that helps to handle metadata.
///
/// The primary convenience that this class provides is the
/// [visitSpecificAnnotationWith] method. A class that extends [MetadataVisitor]
/// should @override [visitAnnotation], passing a function to
/// [visitSpecificAnnotationWith] specific to each individual annotation that
/// you want to analyze.
abstract class MetadataVisitor extends RecursiveAstVisitor {
  final ConstantEvaluator _evaluator = new ConstantEvaluator();

  @override
  Object visitSimpleIdentifier(SimpleIdentifier node) => node.name;

  /// Extracts the value of the argument, labeled [label], from an argument
  /// list.
  ///
  /// The value is visited with the ConstantEvaluator, unless a different
  /// [visitor] is passed.
  extractArgument(List args, String label, {visitor}) {
    visitor ??= _evaluator;
    var arg =
        args.firstWhere((a) => a.name.label.name == label, orElse: () => null);
    return arg?.expression?.accept(visitor);
  }

  // "Visits" the annotation at [node], named [name], by calling [callback].
  //
  // The [callback] function will be be called with the [node] and the arguments
  // passed to the annotation.
  Object visitSpecificAnnotationWith(Annotation node, String name, callback) {
    if (node.name.name != name) return null;
    var args = node?.arguments?.arguments;
    if (args == null) return null;
    return callback(node, args);
  }
}
