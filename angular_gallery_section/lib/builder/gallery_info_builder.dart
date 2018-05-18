// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:path/path.dart';
import 'package:angular_gallery_section/component_info_extraction.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/gallery_section_config_extraction.dart';

/// A builder for generating a json summary of each occurance of a
/// @GallerySectionConfig annotation.
///
/// The json file will be read by other builders that might not have access to
/// a resolver. Reading all the important information here gets around that
/// limitation.
class GalleryInfoBuilder extends Builder {
  final String _staticImageServer;

  GalleryInfoBuilder(this._staticImageServer);

  @override
  build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    final extractedConfigs =
        await extractGallerySectionConfigs(inputId, buildStep);

    // File does not contain @GallerySectionConfig annotation.
    if (extractedConfigs.isEmpty) return;

    final resolvedConfigs = await _resolveConfigs(
        extractedConfigs, await buildStep.inputLibrary, buildStep);

    var newAssetId = inputId.changeExtension('.gallery_info.json');
    buildStep.writeAsString(newAssetId, jsonEncode(resolvedConfigs));
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': const ['.gallery_info.json'],
      };

  /// Resolve the docs and demos within all [configs].
  ///
  /// Will search imports starting at [rootLibrary] for demo classes and
  /// documentation. Reads files with [assetReader] during the search.
  Future<Iterable<ResolvedConfig>> _resolveConfigs(Iterable<ConfigInfo> configs,
          LibraryElement rootLibrary, AssetReader assetReader) async =>
      Future.wait(configs.map((config) async {
        final resolved = new ResolvedConfig()
          ..displayName = config.displayName
          ..benchmarks = config.benchmarks
          ..benchmarkPrefix = config.benchmarkPrefix
          ..owners = config.owners
          ..uxOwners = config.uxOwners
          ..relatedUrls = config.relatedUrls;
        await Future.wait([
          Future.wait(_resolveDocs(config.docs, rootLibrary, assetReader)).then(
              (docs) =>
                  resolved.docs = docs.where((doc) => doc != null).toList()),
          Future
              .wait(_resolveDemos(
                  config.demoClassNames, rootLibrary, assetReader))
              .then((demos) => resolved.demos =
                  demos.where((demo) => demo != null).toList()),
        ]);
        return resolved;
      }));

  /// Resolve all [docs] into a [_DocInfo] that contains the HTML to be rendered
  /// in the gallery.
  ///
  /// Searches imports for documentation starting at [rootLibrary], reading
  /// source files with [assetReader].
  Iterable<Future<_DocInfo>> _resolveDocs(Iterable<String> docs,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (docs == null) return new Iterable.empty();

    return docs.map((doc) async {
      if (doc.startsWith('package:')) {
        // This is a Markdown asset, grab it directly.
        return _readMarkdownAsset(doc, assetReader);
      } else {
        // Assume it is a class that needs to be found.
        final docLibrary = _searchForClass(doc, rootLibrary);

        if (docLibrary == null) {
          log.warning('Could not find @Directive or @Component annotation '
              'to extract documentation: $doc.');
          return null;
        }

        return _resolveDocFromClass(doc, docLibrary, assetReader);
      }
    });
  }

  /// Read the [markdownAsset] with [assetReader] and render as HTML.
  Future<_DocInfo> _readMarkdownAsset(
      String markdownAsset, AssetReader assetReader) async {
    final assetId = new AssetId.resolve(markdownAsset);
    if (extension(assetId.path) != '.md') {
      log.warning('Generator only supports .md files as supplementary docs. '
          'Can not insert $assetId into gallery.');
      return null;
    }

    if (!await assetReader.canRead(assetId)) {
      log.warning('Counld not find the asset: $markdownAsset.');
      return null;
    }

    final content = await assetReader.readAsString(assetId);
    // Convert markdown to html and insert static server for images.
    final htmlContent = _replaceImgTags(g3docMarkdownToHtml(content));

    return new _DocInfo()
      ..name = basenameWithoutExtension(assetId.path)
      ..path = '${assetId.package}/${assetId.path}'
      ..comment = htmlContent;
  }

  /// Find the file that defines [identifier], and extract the documentation
  /// comments, and render as HTML.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<_DocInfo> _resolveDocFromClass(String identifier,
      LibraryElement library, AssetReader assetReader) async {
    final libraryId = new AssetId.resolve(library.source.uri.toString());
    final extractedDoc = extractInfo(await assetReader.readAsString(libraryId),
            path: '${libraryId.path}/${libraryId.package}')
        .directives
        .firstWhere((d) => d.component == identifier, orElse: () => null);

    if (extractedDoc == null) {
      log.warning('Failed to extract documentation from: $identifier.');
      return null;
    }

    // TODO(google) Add the @Input and @Output documentation from:
    // library.getType(docClassName).allSupertypes;

    return new _DocInfo()
      ..name = extractedDoc.component
      ..selector = extractedDoc.selector
      ..path = libraryId.uri.toString()
      ..comment = extractedDoc.comment;
  }

  /// Replace web server in `<img>` tags with the [_staticImageServer].
  String _replaceImgTags(String content) => content.replaceAllMapped(
      new RegExp(r'<img alt="(.*)" src="(\S*g3doc\S+)" \/>'),
      (Match m) => '<img alt="${m[1]}" src="$_staticImageServer${m[2]}" />');

  /// Resolve all [demoClassNames] into [_DemoInfo]s.
  ///
  /// Will search imports starting at [rootLibrary] for the demo classes. Reads
  /// files with [assetReader] during the search.
  Iterable<Future<_DemoInfo>> _resolveDemos(Iterable<String> demoClassNames,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (demoClassNames == null) return new Iterable.empty();
    return demoClassNames.map((demoClassName) async {
      final demoLibrary = _searchForClass(demoClassName, rootLibrary);

      if (demoLibrary == null) {
        log.warning('Could not find Demo class: $demoClassName.');
        return null;
      }
      return _resolveDemo(demoClassName, demoLibrary, assetReader);
    });
  }

  /// Find the file that defines [demoClassName] and extract the information
  /// from the @Component annotation needed to load the demo in the gallery.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<_DemoInfo> _resolveDemo(String demoClassName, LibraryElement library,
      AssetReader assetReader) async {
    final libraryId = new AssetId.resolve(library.source.uri.toString());
    final extractedDemo = extractInfo(await assetReader.readAsString(libraryId),
            path: '${libraryId.path}/${libraryId.package}')
        .directives
        .firstWhere((d) => d.component == demoClassName, orElse: () => null);

    if (extractedDemo == null) {
      log.warning('Failed to extract demo information from: $demoClassName.');
      return null;
    }

    return new _DemoInfo()
      ..type = extractedDemo.type
      ..name = extractedDemo.component
      ..selector = extractedDemo.selector
      ..path = libraryId.uri.toString();
  }

  /// Search imports for the file that defines [identifier] as a class or top
  /// level function, starting from [rootLibrary].
  ///
  /// Searches imports with a breadth-first search, as that should find
  /// [identifier] faster than a depth-first search.
  LibraryElement _searchForClass(
      String identifier, LibraryElement rootLibrary) {
    final visited = new Set<LibraryElement>();
    final toVisit = new Queue<LibraryElement>();

    toVisit.add(rootLibrary);

    while (toVisit.isNotEmpty) {
      final library = toVisit.removeFirst();
      visited.add(library);

      // Search for a class name.
      if (library.getType(identifier) != null) {
        return library;
      }

      // Search for a function name.
      if (library.definingCompilationUnit.functions
          .any((function) => function.name == identifier)) {
        return library;
      }

      toVisit.addAll(library.importedLibraries
          .where((import) => !import.isInSdk && !visited.contains(import)));
      toVisit.addAll(library.exportedLibraries
          .where((export) => !export.isInSdk && !visited.contains(export)));
    }
    // Never found [className] in any of [rootLibrary]'s imports.
    return null;
  }
}

/// Represents the values used to construct an @GallerySectionConfig annotation
/// resolved from raw Strings to the values used by the gallery generators.
class ResolvedConfig {
  String displayName;
  Iterable<_DocInfo> docs;
  Iterable<_DemoInfo> demos;
  Iterable<String> benchmarks;
  String benchmarkPrefix;
  Iterable<String> owners;
  Iterable<String> uxOwners;
  Map<String, String> relatedUrls;

  ResolvedConfig();

  /// Construct a new [ResolvedConfig] from a decoded json map.
  ResolvedConfig.fromJson(Map<String, dynamic> jsonMap) {
    displayName = jsonMap['displayName'] as String;
    docs = (jsonMap['docs'] as Iterable)
        ?.map((element) => new _DocInfo.fromJson(element));
    demos = (jsonMap['demos'] as Iterable)
        ?.map((element) => new _DemoInfo.fromJson(element));
    benchmarks = (jsonMap['benchmarks'] as Iterable)?.cast<String>();
    benchmarkPrefix = jsonMap['benchmarkPrefix'] as String;
    owners = (jsonMap['owners'] as Iterable)?.cast<String>();
    uxOwners = (jsonMap['uxOwners'] as Iterable)?.cast<String>();
    relatedUrls = (jsonMap['relatedUrls'] as Map)?.cast<String, String>();
  }

  /// A json encodeable representation of this [ResolvedConfig].
  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'docs': docs,
        'demos': demos,
        'benchmarks': benchmarks?.toList(),
        'benchmarkPrefix': benchmarkPrefix,
        'owners': owners?.toList(),
        'uxOwners': uxOwners?.toList(),
        'relatedUrls': relatedUrls,
      };
}

/// Represents the docs listed in an @GallerySectionConfig annotation resolved
/// to the values used by the gallery generators.
class _DocInfo {
  String name;
  String selector;
  String path;
  String comment;
  // TODO(google) @Input/@Output documentation will be added here.

  _DocInfo();

  /// Construct a new [_DocInfo] from a decoded json map.
  _DocInfo.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] as String;
    selector = jsonMap['selector'] as String;
    path = jsonMap['path'] as String;
    comment = jsonMap['comment'] as String;
  }

  /// A json encodeable representation of this [_DocInfo].
  Map<String, dynamic> toJson() => {
        'name': name,
        'selector': selector,
        'path': path,
        'comment': comment,
      };
}

/// Represents the demos listed in an @GallerySectionConfig annotation resolved
/// to the values used by the gallery generators.
class _DemoInfo {
  String type;
  String name;
  String selector;
  String path;

  _DemoInfo();

  /// Construct a new [_DocInfo] from a decoded json map.
  _DemoInfo.fromJson(Map<String, dynamic> jsonMap) {
    type = jsonMap['type'] as String;
    name = jsonMap['name'] as String;
    selector = jsonMap['selector'] as String;
    path = jsonMap['path'] as String;
  }

  /// A json encodeable representation of this [_DemoInfo].
  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'selector': selector,
        'path': path,
      };
}
