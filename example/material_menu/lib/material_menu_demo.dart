// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:observable/observable.dart';
import 'package:angular_components/laminate/overlay/zindexer.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_menu/dropdown_menu.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/menu/selectable_menu.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

@Component(
  selector: 'material-menu-demo',
  providers: const [
    popupBindings,
    const Provider(ZIndexer, useClass: ZIndexer)
  ],
  directives: const [
    DropdownMenuComponent,
    MaterialIconComponent,
    MaterialMenuComponent,
  ],
  templateUrl: 'material_menu_demo.html',
  styleUrls: const ['material_menu_demo.scss.css'],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialMenuDemoComponent implements OnDestroy {
  /// Stores the selected color, in an observable manner.
  final SelectionModel<String> colorSelection;

  /// Simple menu with some colors.
  final MenuModel<MenuItem> menuModel;

  /// The same as [menuModel], but with an icon.
  final MenuModel<MenuItem> menuModelWithIcon;

  /// Demonstrates the use of sub menus.
  final MenuModel<MenuItem> nestedMenuModel;

  /// Demonstrates the use of selectable sub menus.
  final MenuModel<MenuItem> selectableMenuModel;

  /// Demonstrates menu items with multiple suffixes.
  final MenuModel<MenuItem> menuModelWithAffixes;

  final Disposer _disposer;

  MaterialMenuDemoComponent._(
      this._disposer,
      this.colorSelection,
      this.menuModel,
      this.menuModelWithIcon,
      this.nestedMenuModel,
      this.selectableMenuModel,
      this.menuModelWithAffixes);

  factory MaterialMenuDemoComponent() {
    var colorSelection = new SelectionModel<String>.withList();
    var makeColorMenuItem = (String color, {MenuModel<MenuItem> subMenu}) =>
        new ColorMenuItem(color, colorSelection, subMenu: subMenu);
    var menuModel = new MenuModel<ColorMenuItem>([
      new MenuItemGroup<ColorMenuItem>([
        makeColorMenuItem('red'),
        makeColorMenuItem('green'),
        makeColorMenuItem('yellow'),
        makeColorMenuItem('black'),
      ])
    ]);

    var menuModelWithIcon =
        new MenuModel<MenuItem>(menuModel.itemGroups, icon: new Icon('menu'));
    var nestedMenuModel = new MenuModel<MenuItem>([
      new MenuItemGroup<MenuItem>([
        new MenuItem('Basic Colors', subMenu: menuModel),
        new MenuItem<ColorMenuItem>('Lights',
            subMenu: new MenuModel<ColorMenuItem>([
              new MenuItemGroup<ColorMenuItem>([
                makeColorMenuItem('Blue',
                    subMenu: new MenuModel<ColorMenuItem>([
                      new MenuItemGroup<ColorMenuItem>([
                        makeColorMenuItem('lightsteelblue'),
                        makeColorMenuItem('lightblue'),
                        makeColorMenuItem('lightskyblue'),
                      ])
                    ])),
                makeColorMenuItem('lightgreen'),
                makeColorMenuItem('lightsalmon'),
                makeColorMenuItem('lightyellow'),
              ])
            ])),
        new MenuItem('Darks',
            subMenu: new MenuModel<ColorMenuItem>([
              new MenuItemGroup<ColorMenuItem>([
                makeColorMenuItem('darkblue'),
                makeColorMenuItem('darkmagenta'),
                makeColorMenuItem('darkkhaki'),
                makeColorMenuItem('darkolivegreen'),
              ])
            ])),
      ])
    ]);

    final disposer = new Disposer.oneShot();

    final metalSelection =
        new SelectionModel<String>.withList(selectedValues: ['O1']);
    final typeSelection = new SelectionModel<String>.withList(allowMulti: true);
    final planeSelection =
        new SelectionModel<String>.withList(allowMulti: true);
    final toolSelection = new SelectionModel<String>.withList(allowMulti: true);

    final chiselItem = new SelectableMenuItem<String>(
        value: 'Chisels',
        subMenu: new MenuModel<MenuItem>([
          new MenuItemGroupWithSelection<String>(items: [
            new SelectableMenuItem<String>(value: 'PMV-11'),
            new SelectableMenuItem<String>(value: 'A2'),
            new SelectableMenuItem<String>(value: 'O1'),
          ], selectionModel: metalSelection, label: 'Steel'),
          new MenuItemGroupWithSelection<String>(items: [
            new SelectableMenuItem<String>(value: 'Mortise'),
            new SelectableMenuItem<String>(value: 'Bench'),
            new SelectableMenuItem<String>(value: 'Paring'),
          ], selectionModel: typeSelection, label: 'Function'),
          new MenuItemGroup<MenuItem>([
            new MenuItem('Help',
                itemSuffixes: new ObservableList.from([
                  new IconAffix(
                      icon: new Icon('help_outline'),
                      visibility: IconVisibility.hover)
                ]),
                action: () => window.alert('halp!')),
          ]),
        ]));

    final planeItem = new SelectableMenuItem<String>(
        value: 'Planes',
        subMenu: new MenuModel<MenuItem>([
          new MenuItemGroupWithSelection<String>(items: [
            new SelectableMenuItem<String>(
                value: 'Bench', selectableState: SelectableOption.Disabled),
            new SelectableMenuItem<String>(value: 'Smoothing'),
            new SelectableMenuItem<String>(value: 'Chisel'),
            new SelectableMenuItem<String>(value: 'Block'),
            new SelectableMenuItem<String>(
                value: 'Shoulder', selectableState: SelectableOption.Disabled),
          ], selectionModel: planeSelection),
        ]));

    disposer.addStreamSubscription(typeSelection.changes.listen((_) {
      if (typeSelection.isNotEmpty) {
        toolSelection.select('Chisels');
      } else {
        toolSelection.deselect('Chisels');
      }
    }));

    disposer.addStreamSubscription(planeSelection.changes.listen((_) {
      if (planeSelection.isNotEmpty) {
        toolSelection.select('Planes');
      } else {
        toolSelection.deselect('Planes');
      }
    }));

    var selectableMenuModel = new MenuModel<MenuItem>([
      new MenuItemGroupWithSelection<String>(items: [
        chiselItem,
        planeItem,
        new SelectableMenuItem<String>(
            value: 'Hidden item', selectableState: SelectableOption.Hidden),
        new SelectableMenuItem<String>(
            value: 'Sandpaper',
            selectableState: SelectableOption.Disabled,
            subMenu: new MenuModel<MenuItem>([
              new MenuItemGroup<MenuItem>([
                new SelectableMenuItem<String>(value: '320'),
                new SelectableMenuItem<String>(value: '150'),
              ]),
            ])),
      ], selectionModel: toolSelection, label: 'Tools'),
      new MenuItemGroup<MenuItem>([
        new MenuItem('Buy',
            subMenu: new MenuModel<MenuItem>([
              new MenuItemGroup<MenuItem>([
                new MenuItem('Almost new',
                    enabled: false, action: () => window.alert('almost new!')),
                new MenuItem('Used', action: () => window.alert('used!')),
                new MenuItem('New', action: () => window.alert('new!')),
              ])
            ])),
        new MenuItem('Advertise',
            subMenu: new MenuModel<MenuItem>([
              new MenuItemGroup<MenuItem>([
                new MenuItem('Google',
                    enabled: false, action: () => window.alert('google!')),
                new MenuItem('Facebook',
                    enabled: false, action: () => window.alert('facebook!')),
                new MenuItem('Craigslist',
                    enabled: false, action: () => window.alert('craigslist!')),
              ])
            ])),
        new MenuItem('Sell'),
      ], 'Unselectable group'),
    ]);

    final menuModelWithAffixes = new MenuModel<MenuItem>([
      new MenuItemGroup<MenuItem>([
        new MenuItem('With no suffixes', action: () => window.alert('1')),
        new MenuItem('With an icon suffix',
            action: () => window.alert('2'),
            itemSuffixes: new ObservableList.from([
              new IconAffix(
                  icon: new IconWithAction(
                      'delete', () => window.alert('action'), 'ariaLabel', null,
                      shouldCloseMenuOnTrigger: true))
            ])),
        new MenuItem('With text suffix',
            action: () => window.alert('3'),
            itemSuffixes:
                new ObservableList.from([new CaptionAffix(text: 'Ctrl + V')])),
        new MenuItem('With multiple suffixes',
            action: () => window.alert('4'),
            itemSuffixes: new ObservableList.from([
              new IconAffix(
                  icon: new IconWithAction('delete',
                      () => window.alert('action 1'), 'ariaLabel', null)),
              new IconAffix(icon: new Icon('accessible')),
              new CaptionAffix(text: 'some text'),
              new IconAffix(icon: new Icon('autorenew')),
            ])),
      ]),
    ]);

    return new MaterialMenuDemoComponent._(
        disposer,
        colorSelection,
        menuModel,
        menuModelWithIcon,
        nestedMenuModel,
        selectableMenuModel,
        menuModelWithAffixes);
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  String get selectedColor => colorSelection.selectedValues.isEmpty
      ? 'red'
      : colorSelection.selectedValues.first;
}

class ColorMenuItem extends MenuItem<ColorMenuItem> {
  ColorMenuItem(String label, SelectionModel selection,
      {Icon icon, MenuModel<MenuItem> subMenu})
      : super(label, icon: icon, subMenu: subMenu) {
    this.action = () {
      selection.select(label);
    };
  }
}
