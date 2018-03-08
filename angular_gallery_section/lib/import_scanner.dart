// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import 'package:build/build.dart';
import 'package:angular_gallery_section/component_info_extraction.dart';
import 'package:angular_gallery_section/visitors/import_visitor.dart';
import 'package:angular_gallery_section/visitors/utils.dart';

/// A tool that searches the imports of a Dart file for a specific Angular
/// component.
///
/// See [scanForComponent], the primary interface to this class, for details.
///
/// Dependent on build, as all assets (imports) are read using
/// [AssetReader.readInputAsString].
class ImportScanner {
  final AssetReader assetReader;

  Queue<AssetId> sourcePaths;
  List<AssetId> scannedPaths;

  ImportScanner(this.assetReader);

  /// Recursively searches the imports of [startingAsset] for
  /// [componentClass].
  ///
  /// Returns a ComponentInfoExtraction for [componentClass] when it
  /// successfully finds it.
  ///
  /// We search imports with a breadth-first search, as that should find
  /// [componentClass] quicker than a depth-first search.
  Future<DirectiveInfo> scanForComponent(
      AssetId startingAsset, String componentClass) async {
    // Queue of paths to scan for imports that might contain [componentClass].
    sourcePaths = new Queue<AssetId>();
    sourcePaths.add(startingAsset);

    // Keep track of paths we've already scanned. In cases of circular
    // dependencies, we won't scan them again.
    scannedPaths = new List<AssetId>();

    while (sourcePaths.isNotEmpty) {
      var source = sourcePaths.removeFirst();
      scannedPaths.add(source);
      var imports = new Map<String, List<String>>();
      var sourceFullPath = '${source.package}/${source.path}';
      var visitor = new ImportVisitor(sourceFullPath, imports, imports);
      var content = await assetReader.readAsString(source);
      visitCompilationUnit(content, visitor, path: sourceFullPath);
      // First check the current file.
      var sourceInfo = extractInfo(content, path: sourceFullPath);

      for (var info in sourceInfo.directives) {
        if (info.component == componentClass) {
          return info;
        }
      }

      for (List<String> importPaths in imports.values) {
        var info = await _scanImportPaths(importPaths, componentClass);
        if (info != null) return info;
      }
    }

    // Never found [componentClass] in any of [sourceFile]'s imports.
    return null;
  }

  Future<DirectiveInfo> _scanImportPaths(
      var importPaths, var componentClass) async {
    for (String path in importPaths) {
      // We're not going to find [componentClass] in the Dart SDK.
      if (path.startsWith('dart:')) continue;

      var importAssetId = _assetIdFromImport(path);
      if (!scannedPaths.contains(importAssetId)) {
        // Add this import to [sourcePaths], to check its imports and components
        // later.
        sourcePaths.add(importAssetId);
      }
      // Check [sourcePath] itself for [componentClass].
      var content = await assetReader.readAsString(importAssetId);
      var sourceInfo = extractInfo(content,
          path: '${importAssetId.package}/${importAssetId.path}');

      for (var info in sourceInfo.directives) {
        if (info.component == componentClass) {
          return info;
        }
      }
    }

    // We didn't find [componentClass] in [path].
    return null;
  }

  AssetId _assetIdFromImport(String path) {
    path = path.replaceFirst('package:', '');
    var parts = path.split('/');
    var assetPackage = parts.removeAt(0);
    var assetPath = parts.join('/');
    return new AssetId(assetPackage, 'lib/$assetPath');
  }

  bool _importIsThirdParty(String path) =>
      path.startsWith('package:') && !path.split('/')[0].contains('.');
}
