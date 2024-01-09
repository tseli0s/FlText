// ignore_for_file: unused_element

/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023-2024 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'dart:io';

import 'package:fltext/settings_screen.dart';
import 'package:fltext/text_edit.dart';
import 'package:fltext/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_bar/menu_bar.dart';

class TabbedTextEditor extends StatefulWidget {
  final List<String> filesOpen = [];

  TabbedTextEditor({super.key, String? filename}) {
    filesOpen.add(filename ?? "");
  }

  @override
  State<StatefulWidget> createState() => TabbedTextEditorState();
}

class TabbedTextEditorState extends State<TabbedTextEditor> {
  @override
  Widget build(BuildContext context) {
    var l = 0;
    final List<Widget> tabs = [];
    final List<Widget> children = [];

    for (final f in widget.filesOpen) {
      tabs.add(
        Tab(
          icon: const Icon(Icons.file_open),
          text: f != "" ? f : "* New file",
        ),
      );
      children.add(
        TextEditor(
          filename: f != "" ? f : null,
        ),
      );
      l++;
    }

    /*
    return DefaultTabController(
      length: l,
      child: Scaffold(
        appBar: TabBar(tabs: tabs),
        body: TabBarView(children: children),
      ),
    );
    */
    return SafeArea(
      child: MenuBarWidget(
        barButtons: [
          BarButton(
            text: const Text('File'),
            submenu: SubMenu(
              menuItems: [
                MenuButton(
                  text: const Text('Save as'),
                  onTap: () {},
                  icon: const Icon(Icons.save),
                  shortcutText: 'Ctrl+S',
                ),
                const MenuDivider(),
                MenuButton(
                  text: const Text('Back to home'),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.exit_to_app),
                ),
                const MenuDivider(),
                MenuButton(
                  text: const Text('Exit'),
                  onTap: () {
                    exit(0);
                  },
                  icon: const Icon(Icons.exit_to_app),
                  shortcutText: 'Ctrl+Q',
                ),
              ],
            ),
          ),
          BarButton(
            text: const Text('Edit'),
            submenu: SubMenu(
              menuItems: [
                MenuButton(
                  text: const Text('Preferences...'),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          title: "Preferences",
                          builder: (ctx) {
                            return const SettingsScreen();
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
          BarButton(
            text: const Text('Help'),
            submenu: SubMenu(
              menuItems: [
                MenuButton(
                  text: const Text('View License'),
                  onTap: () {
                    showLicense(context);
                  },
                ),
                MenuButton(
                  text: const Text('About'),
                  onTap: () {
                    showFltextAbout(context);
                  },
                  icon: const Icon(Icons.info),
                ),
              ],
            ),
          ),
        ],
        child: DefaultTabController(
          length: l,
          child: Scaffold(
            appBar: TabBar(tabs: tabs),
            body: TabBarView(children: children),
          ),
        ),
      ),
    );
  }
}
