// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';

import 'src/common_extractors.dart';

/// Extracts a [DocumentationInfo] from [assetId] for the identifier [name].
///
/// Will read [assetId] with [assetReader].
Future<DocumentationInfo> extractDocumentation(
        String name, AssetId assetId, AssetReader assetReader) async =>
    parseCompilationUnit(await assetReader.readAsString(assetId),
            parseFunctionBodies: false)
        .accept(new GalleryDocumentaionExtraction(name));

/// A visitor that extracts a [DocumentationInfo] for an identifier [_name] and
/// additional information from the Angular annotations @Component and
/// @Directive (if present) for documentation purposes.
class GalleryDocumentaionExtraction
    extends SimpleAstVisitor<DocumentationInfo> {
  final String _name;
  DocumentationInfo _info;

  GalleryDocumentaionExtraction(this._name);

  @override
  visitCompilationUnit(CompilationUnit node) {
    for (final declaration in node.declarations) {
      final info = declaration.accept(this);
      if (info != null) return info;
    }
  }

  @override
  visitClassDeclaration(ClassDeclaration node) => _extractDocumentation(node);
  // TODO(google) Collect extra class member docs here like @Input/@Output.

  @override
  visitFunctionDeclaration(FunctionDeclaration node) =>
      _extractDocumentation(node);

  @override
  visitAnnotation(Annotation node) {
    final args = node?.arguments?.arguments;
    if (args == null) return null;

    _info.type = node.name.name;
    args.accept(this);
  }

  @override
  visitNamedExpression(NamedExpression node) {
    final name = node.name.label.name;
    final expression = node.expression;
    if (name == 'selector') {
      _info.selector = expression.accept(new StringExtractor());
    }
  }

  /// Collect information needed for documentaiton from [node].
  DocumentationInfo _extractDocumentation(NamedCompilationUnitMember node) {
    if (node.name.name != _name) return null;

    _info = new DocumentationInfo()
      ..name = node.name.name
      ..comment = parseComment(node.documentationComment);
    node.metadata
        .firstWhere((annotation) => _isAngularDirective(annotation),
            orElse: () => null)
        ?.accept(this);
    return _info;
  }

  /// If the annotation [node] contains information for the Angular annotations
  /// @Component or @Directive
  bool _isAngularDirective(Annotation node) =>
      node.name.name == 'Directive' || node.name.name == 'Component';

  static final RegExp _singleLineCommentStart = new RegExp(r'^///? ?(.*)');
  static final RegExp _multiLineCommentStartEnd =
      new RegExp(r'^/\*\*? ?([\s\S]*)\*/$', multiLine: true);
  static final RegExp _multiLineCommentLineStart =
      new RegExp(r'^[ \t]*\* ?(.*)');

  /// Pulls the raw text out of a comment (i.e. removes the comment
  /// characters).
  String parseComment(Comment commentNode) {
    if (commentNode == null) {
      return '';
    }

    // Handle ///-style comments
    if (commentNode.tokens
        .every((t) => _singleLineCommentStart.hasMatch(t.lexeme))) {
      return commentNode.tokens
          .map((t) => _singleLineCommentStart.firstMatch(t.lexeme)[1])
          .join('\n');
    }

    // Handle /* */-style comments
    String comment = commentNode.tokens.single.lexeme;
    Match match = _multiLineCommentStartEnd.firstMatch(comment);
    if (match != null) {
      comment = match[1];
      var sb = new StringBuffer();
      List<String> lines = comment.split('\n');
      for (int index = 0; index < lines.length; index++) {
        String line = lines[index].trimRight();
        if (index == 0) {
          sb.write(line); // Add the first line unprocessed.
          continue;
        }
        sb.write('\n');
        match = _multiLineCommentLineStart.firstMatch(line);
        if (match != null) {
          sb.write(match[1]);
        } else {
          sb.write(line);
        }
      }
      return sb.toString().trim();
    }
    throw new ArgumentError('Invalid comment $comment');
  }
}

/// Information used for documenation in the gallery.
class DocumentationInfo {
  /// The path in which this component was found.
  String name;
  String type;
  String selector;
  String comment;
}
