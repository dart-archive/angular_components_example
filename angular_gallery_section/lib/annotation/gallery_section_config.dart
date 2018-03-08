// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An annotation for configuring a section in an Angular component gallery.
///
/// A section is typically equivalent to a package that contains one or a few
/// related components.
class GallerySectionConfig {
  /// The name of the component which is being demonstrated, to be listed in a
  /// gallery's navigation menu.
  final String displayName;

  /// A list of component classes to pull Dart doc comments from.
  ///
  /// Specify docs in the order that they should be displayed.
  final List<dynamic /* Type | Function */ > docs;

  /// A list of example component classes to include in the section.
  ///
  /// Specify demos in the order that they should be displayed.
  final List<Type> demos;

  /// A list of latency test names to include in charts on the API page.
  ///
  /// Specify the latency names in the order they should be displayed.
  final List<String> benchmarks;

  /// A string prefix for acx benchmarks, defaults to 'acx_benchmarks_guitar'.
  final String benchmarkPrefix;

  /// A list of owners for the components in this section.
  final List<String> owners;

  /// A list of UX owners for the components in this section.
  final List<String> uxOwners;

  /// Titles and urls of related documents.
  final Map<String, String> relatedUrls;

  const GallerySectionConfig(
      {this.displayName,
      this.docs,
      this.demos,
      this.benchmarks,
      this.benchmarkPrefix,
      this.owners,
      this.uxOwners,
      this.relatedUrls});
}
