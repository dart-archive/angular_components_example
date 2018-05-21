// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';

/// Extracts the information from @GallerySectionConfig annotations.
///
/// The asset identified by [assetId] will be read using [assetReader].
Future<Iterable<ConfigInfo>> extractGallerySectionConfigs(
        AssetId assetId, AssetReader assetReader) async =>
    parseCompilationUnit(await assetReader.readAsString(assetId),
            parseFunctionBodies: false)
        .accept(new GallerySectionConfigExtraction());

/// [AstVisitor] to extract multiple @GallerySectionConfig annotations, and
/// the parameters they are constructed with.
class GallerySectionConfigExtraction
    extends SimpleAstVisitor<Iterable<ConfigInfo>> {
  @override
  visitCompilationUnit(CompilationUnit node) => node.declarations
      .map((delcaration) =>
          delcaration.accept(new _GallerySectionConfigVisitor()))
      .where((config) => config != null);
}

/// [AstVisitor] to extract a single @GallerySectionConfig annotation, applied
/// to a class declaration.
///
/// For use by a [GallerySectionConfigExtraction].
class _GallerySectionConfigVisitor extends SimpleAstVisitor<ConfigInfo> {
  ConfigInfo config;

  @override
  visitClassDeclaration(ClassDeclaration node) {
    for (final metadata in node.metadata) {
      if (metadata.name.name == 'GallerySectionConfig') {
        config = new ConfigInfo()..annotatedClassName = node.name.name;
        metadata.accept(this);
      }
    }
    return config;
  }

  @override
  visitAnnotation(Annotation node) {
    final args = node?.arguments?.arguments;
    if (args == null) return null;

    final ClassDeclaration parent = node.parent;
    config.annotatedClassName = parent.name.name;
    args.accept(this);
  }

  @override
  visitNamedExpression(NamedExpression node) {
    final name = node.name.label.name;
    final expression = node.expression;
    if (name == 'displayName') {
      config.displayName = expression.accept(new _StringExtractor());
    } else if (name == 'docs') {
      config.docs = expression.accept(new _ListStringExtractor());
    } else if (name == 'demos') {
      config.demoClassNames = expression.accept(new _ListStringExtractor());
    } else if (name == 'benchmarks') {
      config.benchmarks = expression.accept(new _ListStringExtractor());
    } else if (name == 'benchMarkPrefix') {
      config.benchmarkPrefix = expression.accept(new _StringExtractor());
    } else if (name == 'owners') {
      config.owners = expression.accept(new _ListStringExtractor());
    } else if (name == 'uxOwners') {
      config.uxOwners = expression.accept(new _ListStringExtractor());
    } else if (name == 'relatedUrls') {
      config.relatedUrls = expression.accept(new _MapStringExtractor());
    }
  }
}

/// [AstVisitor] to extract a [SimpleStringLiteral]s or [SimpleIdentifier]s.
///
/// For use by a [_GallerySectionConfigVisitor].
class _StringExtractor extends SimpleAstVisitor<String> {
  @override
  visitSimpleStringLiteral(SimpleStringLiteral node) => node.value;

  @override
  visitSimpleIdentifier(SimpleIdentifier node) => node.name;
}

/// [AstVisitor] to extract a [ListLiteral].
///
/// For use by a [_GallerySectionConfigVisitor].
class _ListStringExtractor extends SimpleAstVisitor<Iterable<String>> {
  @override
  visitListLiteral(ListLiteral node) =>
      node.elements.map((element) => element.accept(new _StringExtractor()));
}

/// [AstVisitor] to extract a [MapLiteral] and [MapLiteralEntry].
///
/// For use by a [_GallerySectionConfigVisitor].
class _MapStringExtractor extends SimpleAstVisitor<Map<String, String>> {
  @override
  visitMapLiteral(MapLiteral node) =>
      new Map.fromEntries(node.entries.map((entry) => new MapEntry(
          entry.key.accept(new _StringExtractor()),
          entry.value.accept(new _StringExtractor()))));
}

/// Represents the values used to construct an @GallerySectionConfig annotation
/// extracted as Strings.
class ConfigInfo {
  String annotatedClassName;
  String displayName;
  Iterable<String> docs;
  Iterable<String> demoClassNames;
  Iterable<String> benchmarks;
  String benchmarkPrefix;
  Iterable<String> owners;
  Iterable<String> uxOwners;
  Map<String, String> relatedUrls;
}
