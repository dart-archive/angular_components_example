import 'package:angular_components/angular_components.dart';
import 'package:angular2/angular2.dart';

/// An example that renders a [MaterialTreeComponent] with nested options.
///
/// Options are selected and managed by [singleSelection].
@Component(
    selector: 'material-tree-demo',
    templateUrl: 'material_tree_demo.html',
    styleUrls: const ['material_tree_demo.css'],
    directives: const [MaterialTreeComponent],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialTreeDemoComponent {
  final SelectionOptions nestedOptions = new _NestedSelectionOptions([
    new OptionGroup(
        ['Animated Feature Films', 'Live-Action Films', 'Documentary Films'])
  ], {
    'Animated Feature Films': [
      new OptionGroup([
        'Cinderalla',
        'Alice In Wonderland',
        'Peter Pan',
        'Lady and the Tramp',
      ])
    ],
    'Live-Action Films': [
      new OptionGroup(
          ['Treasure Island', 'The Littlest Outlaw', 'Old Yeller', 'Star Wars'])
    ],
    'Documentary Films': [
      new OptionGroup(['Frank and Ollie', 'Sacred Planet'])
    ],
    'Star Wars': [
      new OptionGroup(['By George Lucas'])
    ],
    'By George Lucas': [
      new OptionGroup(
          ['A New Hope', 'Empire Strikes Back', 'Return of the Jedi'])
    ]
  });

  final SelectionModel singleSelection = new SelectionModel.withList();
  final ChangeDetectorRef _changeDetector;

  MaterialTreeDemoComponent(this._changeDetector);

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;

  bool _expandAll = false;
  bool get expandAll => _expandAll;
  set expandAll(bool value) {
    _expandAll = value;
    _changeDetector.markForCheck();
  }

  String get selection =>
      singleSelection.isEmpty ? '' : singleSelection.selectedValues.first;
}

/// An example implementation of [SelectionOptions] with [Parent].
class _NestedSelectionOptions<T> extends SelectionOptions<T>
    implements Parent<T, List<OptionGroup<T>>> {
  final Map<T, List<OptionGroup<T>>> _children;

  _NestedSelectionOptions(List<OptionGroup<T>> options, this._children)
      : super(options);

  @override
  bool hasChildren(T item) => _children.containsKey(item);

  @override
  DisposableFuture<List<OptionGroup<T>>> childrenOf(T parent, [_]) {
    return new DisposableFuture<List<OptionGroup<T>>>.fromValue(
        _children[parent]);
  }
}
