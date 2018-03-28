// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:angular_gallery_section/config_extraction.dart';

/// A builder for generating a summary of the API page for an Angular component.
///
/// The "summary" is generated with the known filename
/// (gallery_section_summary.json) so it can be read across packages while
/// generating the gallery library. It is a json dictionary naming the important
/// features of the gallery section API page.
class GallerySectionSummaryBuilder extends Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final summaries = new List<Map<String, dynamic>>();

    // Extract details from @GallerySectionConfig annotations.
    await for (var assetId in buildStep.findAssets(new Glob('**/*.dart'))) {
      final configExtraction = await resolveGalleryConfig(buildStep, assetId);
      if (configExtraction == null) continue;

      summaries.add({
        'displayName': configExtraction.displayName,
        'dartImport': _toApiTemplatePath(assetId.uri.toString()),
        'componentClass': '${configExtraction.componentClass}Api',
        'docs': configExtraction.docs
      });
    }

    final newAssetId =
        new AssetId(inputId.package, 'lib/gallery_section_summary.json');
    buildStep.writeAsString(newAssetId, json.encode(summaries));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': const ['gallery_section_summary.json'],
      };

  String _toApiTemplatePath(String path) =>
      "${path.substring(0, path.lastIndexOf('.dart'))}.api.template.dart";
}
