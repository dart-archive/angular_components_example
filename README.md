This is a basic gallery of the various AngularDart Components.

* **[See the gallery](https://dart-lang.github.io/angular_components_example/)**
* [See the code](https://github.com/dart-lang/angular_components_example/blob/master/lib/app_component.html)
* [Use the package](https://pub.dartlang.org/packages/angular_components)
* [Browse the API](https://www.dartdocs.org/documentation/angular_components/latest)

For a walk-through of how to *use* these components, see
[Code Lab: AngularDart Components](https://webdev.dartlang.org/codelabs/angular2_components).

## Development

As of angular: 5.0.0-alpha+5 the pub transformer has been removed in favor of
code generation through package [build]. This package must be built with package
[build_runner].

### Build

Build the package to the given directory.

```
pub run build_runner build --output <output directory>
```

### Serve

Run a local development server with a file watcher and incremental rebuilds:

```
pub run build_runner serve
```

Both of the build and serve commands can use `--config release` to build with
dart2js instead of the the default dartdevc.

[build_runner]: https://pub.dartlang.org/packages/build_runner
[build]: https://pub.dartlang.org/packages/build

### Test

Run `dart tool/sanity_check.dart` to execute a simple Selenium test of the
gallery.
