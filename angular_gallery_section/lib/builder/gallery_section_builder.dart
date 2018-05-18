// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:mustache/mustache.dart' show Template;

import 'gallery_info_builder.dart' show ResolvedConfig;

/// A builder for generating a "gallery section" (Dart source code) from a
/// @GallerySectionConfig construction.
///
/// Primarily, this tool creates a combined demo of the "demos" attached to the
/// GallerySectionConfig.
class GallerySectionBuilder extends Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final infoAssets =
        await buildStep.findAssets(new Glob('**/*.gallery_info.json')).toList();
    if (infoAssets.isEmpty) return;

    final mergedImports = new Set<String>();
    final mergedDemos = <String, String>{};

    for (final assetId in infoAssets) {
      final infoList =
          (jsonDecode(await buildStep.readAsString(assetId)) as List)
              .map((info) => new ResolvedConfig.fromJson(info));

      for (final info in infoList) {
        for (final demo in info.demos) {
          mergedDemos[demo.name] = demo.selector;
          mergedImports.add(demo.path);
        }
      }
    }

    final mustacheContext = {
      'imports': mergedImports.map((import) => {'dartImport': import}),
      'demos': mergedDemos.entries
          .map((entry) => {'className': entry.key, 'selector': entry.value}),
    };

    final templateId = new AssetId('angular_gallery_section',
        'lib/builder/template/gallery_section.dart.mustache');
    final mustacheTemplate = new Template(
        await buildStep.readAsString(templateId),
        htmlEscapeValues: false);

    final newAssetId = new AssetId(inputId.package, 'lib/gallery_section.dart');
    buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': const ['gallery_section.dart'],
      };
}
