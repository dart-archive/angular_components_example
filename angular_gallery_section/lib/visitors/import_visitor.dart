// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:path/path.dart' as path;

import 'utils.dart';

/// A visitor that collects import paths and export paths in a Dart source.
class ImportVisitor extends RecursiveAstVisitor {
  String libraryName;

  final Map<String, List<String>> _exportStatements;
  final Map<String, List<String>> _importStatements;

  List<String> _exportsForCurrentFile;
  List<String> _importsForCurrentFile;
  String _baseDir;

  /// Instantiates an ImportVisitor with a Map of [_importStatements] and,
  /// optionally, a Map of [_exportStatements].
  ///
  /// * [baseFile] is the path of the file that is being visited. This will be
  ///   used to reconstruct relative paths.
  /// * [_importStatements] is a Map where import paths will be collected.
  ///   ImportVisitor will add import paths to a value in the Map, paired to the
  ///   package URI form of [baseFile] as the key (likewise for export paths and
  ///   [_exportStatements]).
  ImportVisitor(String baseFile, this._importStatements,
      [this._exportStatements]) {
    _baseDir = path.dirname(baseFile) + '/';
    _importsForCurrentFile =
        _importStatements.putIfAbsent(pathToPackageUri(baseFile), () => []);
    if (_exportStatements != null) {
      _exportsForCurrentFile =
          _exportStatements.putIfAbsent(pathToPackageUri(baseFile), () => []);
    }
  }

  @override
  void visitLibraryDirective(LibraryDirective directive) {
    libraryName = directive.name.name;
  }

  @override
  void visitExportDirective(ExportDirective directive) {
    if (_exportStatements == null) return;

    var exportNode = directive.uri.stringValue;
    if (!exportNode.contains(':')) {
      exportNode = pathToPackageUri(_baseDir + exportNode);
    }
    _exportsForCurrentFile.add(exportNode);
  }

  @override
  void visitImportDirective(ImportDirective directive) {
    var importNode = directive.uri.stringValue;
    if (!importNode.contains(':')) {
      importNode = pathToPackageUri(_baseDir + importNode);
    }
    _importsForCurrentFile.add(importNode);
  }
}
