// ignore_for_file: use_build_context_synchronously

/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
import 'package:fltext/config.dart';
import 'package:fltext/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Color(accentColor),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.font_download),
            title: Text(AppLocalizations.of(context)!.editorFont),
            subtitle: Text(AppLocalizations.of(context)!.editorFont_t),
          ),
          ListTile(
            leading: const Icon(Icons.colorize),
            title: const Text("Color scheme"),
            subtitle: const Text(
              "Select the color scheme used by the application",
            ),
            onTap: () async {
              final result = await colorPickerDialog(context);
              if (result) {
                saveConfigChanges();
                /* TODO: Translations */
                final snackBar = SnackBar(
                  content: const Text(
                    "You will have to restart the editor to see the new changes.",
                  ),
                  padding: const EdgeInsets.all(16.0),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  action: SnackBarAction(
                    label: "Close",
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const ListTile(
            enabled: false,
            leading: Icon(Icons.dark_mode),
            title: Text("Light/dark theme"),
            subtitle: Text(
              "Coming soon!",
            ),
          ),
        ],
      ),
    );
  }
}
