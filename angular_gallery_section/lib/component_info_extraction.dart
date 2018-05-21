// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:angular_gallery_section/visitors/metadata_visitor.dart';
import 'package:angular_gallery_section/visitors/utils.dart';

/// Convenience method, returning a ComponentInfoExtraction after visiting the
/// parsed [code].
///
/// [path] is only used for error-reporting.
ComponentInfoExtraction extractInfo(String code, {String path: 'file'}) {
  var visitor = new ComponentInfoExtraction(path: path);
  visitCompilationUnit(code, visitor, path: path);
  return visitor;
}

/// A visitor that extracts info from an Angular @Component defined in some
/// Dart code, for documentation purposes.
class ComponentInfoExtraction extends MetadataVisitor {
  final String path;
  List<DirectiveInfo> directives = <DirectiveInfo>[];

  ComponentInfoExtraction({this.path});

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    node.metadata.forEach((m) {
      m.accept(this);
    });
  }

  @override
  void visitAnnotation(Annotation node) {
    visitSpecificAnnotationWith(node, 'Component', _visitDirective);
    visitSpecificAnnotationWith(node, 'Directive', _visitDirective);
  }

  _visitDirective(Annotation node, List args) {
    NamedCompilationUnitMember parent = node.parent;
    var info = new DirectiveInfo()
      ..path = path
      ..type = node.name.name
      ..component = parent.name.name
      ..comment = parseComment(parent.documentationComment)
      ..selector = extractArgument(args, 'selector');
    directives.add(info);
  }

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

/// Information about a directive.
class DirectiveInfo {
  /// The path in which this component was found.
  String path;
  String type;
  String selector;
  String component;
  String comment;
}
