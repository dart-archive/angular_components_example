// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:mustache/mustache.dart' show Template;
import 'package:angular_gallery_section/config_extraction.dart';

/// A builder for generating a "gallery section" (Dart source code) from a
/// @GallerySectionConfig construction.
///
/// Primarily, this tool creates a combined demo of the "demos" attached to the
/// GallerySectionConfig.
class GallerySectionBuilder extends Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    Map<String, dynamic> mustacheContext;

    await for (var assetId in buildStep.findAssets(new Glob('**/*.dart'))) {
      final configExtraction = await resolveGalleryConfig(buildStep, assetId);
      if (configExtraction == null) continue;

      if (mustacheContext != null) {
        log.warning('Generator does not support multiple @GallerySectionConfig'
            ' annotations in a single lib directory.');
        continue;
      }

      final imports = new Set.from(
          configExtraction.demos.map((demo) => demo.path.split('lib/')[1]));

      mustacheContext = {
        'className': configExtraction.componentClass,
        'componentSelector': configExtraction.componentSelector,
        'imports': imports.map((i) => {'dartImport': i}),
        'demos': configExtraction.demos.map(
            (demo) => {'className': demo.component, 'selector': demo.selector})
      };
    }

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
