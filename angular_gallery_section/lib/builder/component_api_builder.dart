// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:mustache/mustache.dart' show Template;
import 'package:path/path.dart';
import 'package:angular_gallery_section/config_extraction.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/import_scanner.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as paths;

/// A builder for generating an API page for an Angular component.
///
/// The "API page" is in the form of Dart code, with an Angular component
/// whose template includes information about a component annotated with
/// @GallerySectionConfig.
class ComponentApiBuilder extends Builder {
  static const libPath = 'lib/';
  final String _staticImageServer;

  static final List<String> _defaultMetrics = [
    'pureScriptTime',
    'renderTime',
    'cold_pureScriptTime',
    'cold_renderTime',
  ];
  static final String _defaultPlatform = '_chrome-win7';
  static final String _defaultProject = 'acx_benchmarks_guitar';

  ComponentApiBuilder(this._staticImageServer);

  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    // Extract details from @GallerySectionConfig annotation.
    final configExtraction = await resolveGalleryConfig(buildStep, inputId);
    if (configExtraction == null) return;

    final mustacheContext = await _mustacheContext(buildStep, configExtraction);
    final templateId = new AssetId('angular_gallery_section',
        'lib/builder/template/component.api.dart.mustache');
    final mustacheTemplate = new Template(
        await buildStep.readAsString(templateId),
        htmlEscapeValues: false);
    final newAssetId = inputId.changeExtension('.api.dart');
    buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': const ['.api.dart']
      };

  // Search for assets and classes that are to be documented, and add their docs
  // to the mustache context.
  //
  // To be used when [inputFile] contains an @GallerySectionConfig with a
  // 'docs:' parameter.
  Future<List<Map<String, dynamic>>> _findDocsMap(
      BuildStep buildStep, List<String> docs) async {
    final importScanner = new ImportScanner(buildStep);
    final results = <Map<String, dynamic>>[];

    for (var doc in docs) {
      // First look for the assset directly
      if (doc.startsWith('package:')) {
        // This is an asset grab it directly.
        final asset = new AssetId.resolve(doc);
        if (extension(asset.path) != '.md') {
          throw new UnsupportedError('Generator only supports .md files as '
              'supplementary docs. Can not insert $asset into gallery.');
        }
        final content = await buildStep.readAsString(asset);
        // Convert markdown to html and insert static server for images.
        final htmlContent = g3docMarkdownToHtml(content).replaceAllMapped(
            new RegExp(r'<img alt="(.*)" src="(\S*g3doc\S+)" \/>'),
            (Match m) =>
                '<img alt="${m[1]}" src="$_staticImageServer${m[2]}" />');

        results.add({
          'name': basenameWithoutExtension(asset.path),
          'selector': '',
          'path': '${asset.package}/${asset.path}',
          'comment': htmlContent
        });
      } else {
        // Assume it is a class or function that needs to be found.
        final info =
            await importScanner.scanForComponent(buildStep.inputId, doc);
        if (info == null) continue;

        results.add({
          'name': info.component,
          'selector': info.selector,
          'path': info.path,
          'comment': g3docMarkdownToHtml(info.comment)
        });
      }
    }

    return results;
  }

  /// Returns a context with the useful values from the [configExtraction].
  ///
  /// The import graph is traversed with [assetReader] during the collection
  /// process.
  Future<Map<String, dynamic>> _mustacheContext(
      AssetReader assetReader, ConfigExtraction configExtraction) async {
    final demos = configExtraction.demos.map((demo) => {
          'className': demo.component,
          'dartImport': demo.path.split(libPath)[1],
          'examplePath': paths.assetLocationToPath(demo.path),
        });

    // If multiple components are defined in a demo file, we would end up with
    // duplicate imports, so de dup them.
    final dedupedImports =
        new Set.from(demos.map((demo) => demo['dartImport']));
    final demoImports = [];
    for (var import in dedupedImports) {
      demoImports.add({'dartImport': import});
    }

    final docs = configExtraction.docs == null
        ? <String>[]
        : await _findDocsMap(assetReader, configExtraction.docs);

    final relatedUrls = [];
    if (configExtraction.relatedUrls?.isNotEmpty == true) {
      configExtraction.relatedUrls.forEach((key, value) {
        relatedUrls.add({'key': key, 'value': value});
      });
    }

    return {
      'component': configExtraction.componentClass,
      'selector': configExtraction.componentSelector,
      'demos': demos ?? [],
      'demoImports': demoImports,
      'docs': docs,
      'benchmarks': [],
      'owners': configExtraction.owners ?? [],
      'uxOwners': configExtraction.uxOwners ?? [],
      'relatedUrls': relatedUrls,
    };
  }
}
