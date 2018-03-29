// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';
import 'package:angular_gallery_section/component_info_extraction.dart';
import 'package:angular_gallery_section/import_scanner.dart';
import 'package:angular_gallery_section/visitors/metadata_visitor.dart';
import 'package:angular_gallery_section/visitors/utils.dart';
import 'package:angular_components/utils/strings/string_utils.dart' as string;

final _invalidCharacters = new RegExp(r'[^a-zA-Z0-9 ]');

/// Convenience method, creating and returning a [ConfigExtraction] after
/// visiting the parsed [code].
///
/// [path] is only used for error-reporting.
ConfigExtraction extractConfig(String code, {String path: 'file'}) {
  var visitor = new ConfigExtraction(path);
  visitCompilationUnit(code, visitor, path: path);
  return visitor.sectionClass == null ? null : visitor;
}

/// Convenience method, creating and returning a [ConfigExtraction] after
/// reading the [source] asset and then resolving [ComponentInfoExtraction] for
/// each demo.
Future<ConfigExtraction> resolveGalleryConfig(
    AssetReader assetReader, AssetId source) async {
  var code = await assetReader.readAsString(source);
  var visitor = extractConfig(code, path: '${source.package}/${source.path}');
  if (visitor != null) await visitor.resolveDemos(assetReader, source);
  return visitor;
}

/// [AstVisitor] that finds a @[GallerySectionConfig] annotation, storing the
/// parameters that it was constructed with.
class ConfigExtraction extends MetadataVisitor {
  String sectionClass;
  String displayName;
  List docs;
  List demoClasses;
  List benchmarks;
  String benchmarkPrefix;
  List owners;
  List uxOwners;
  Map relatedUrls;
  List<DirectiveInfo> demos;

  // Just used for better error message.
  final String _file;

  ConfigExtraction(this._file);

  @override
  visitClassDeclaration(ClassDeclaration node) {
    for (var metadata in node.metadata) {
      if (metadata.accept(this) != null) {
        if (sectionClass != null) {
          throw new StateError('Can only define one GallerySectionConfig. '
              'Found multiple: $sectionClass, $componentSelector '
              'in file: $_file');
        }
        sectionClass = node.name.name;
      }
    }
  }

  @override
  visitAnnotation(Annotation node) => visitSpecificAnnotationWith(
      node, 'GallerySectionConfig', _visitGallerySectionConfig);

  _visitGallerySectionConfig(Annotation node, List args) {
    displayName = extractArgument(args, 'displayName');
    docs = extractArgument(args, 'docs', visitor: this);
    demoClasses = extractArgument(args, 'demos', visitor: this);
    benchmarks = extractArgument(args, 'benchmarks');
    benchmarkPrefix = extractArgument(args, 'benchmarkPrefix');
    owners = extractArgument(args, 'owners');
    uxOwners = extractArgument(args, 'uxOwners');
    relatedUrls = extractArgument(args, 'relatedUrls');
    return node;
  }

  @override
  visitListLiteral(ListLiteral node) =>
      node.elements.map((element) => element.accept(this)).toList();

  // TODO: Uniquify this name, or fail if it collides with another class.
  /// A name for a Dart class that can be used if making a Component from
  /// this GalleryConfigSection.
  String get componentClass =>
      '${string.camelCase(_cleanName(displayName))}GallerySection';

  /// A name for a Component selector that can be used if making a Component
  /// from this GalleryConfigSection.
  String get componentSelector =>
      '${string.hyphenate(_cleanName(displayName))}-gallery-section';

  Future resolveDemos(AssetReader assetReader, AssetId source) async {
    demos = [];
    for (var demoClass in demoClasses) {
      // TODO(google): reuse the state of the import scanner.
      var info = await new ImportScanner(assetReader)
          .scanForComponent(source, demoClass);
      if (info != null) {
        demos.add(info);
      } else {
        throw new StateError('Demo component "$demoClass" not found in '
            '$_file or any of its imports.');
      }
    }
  }

  @override
  Object visitSimpleStringLiteral(SimpleStringLiteral node) => node.value;

  /// Replace all characters that are not letters, numbers or spaces with an
  /// underscore.
  ///
  /// Compresses contiguous whitespace down to a single space after stripping
  /// out unwanted characters.
  String _cleanName(input) {
    var stripped = input.replaceAll(_invalidCharacters, '_');
    // Compress contiguous whitespace down to a signle space in final result.
    return stripped.replaceAll(new RegExp(r' {2,}'), ' ');
  }
}
