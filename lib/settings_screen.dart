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
            leading: Checkbox(
              value: useMonospace,
              onChanged: (v) {
                useMonospace = v!;
                saveConfigChanges();
                setState(() {});
              },
            ),
            title: const Text("Use monospaced font"),
            subtitle: const Text(
              "Use the platform's monospaced font instead of the system font. May help with readability.",
            ),
          ),
          /* TODO: Implement font selection. */
          ListTile(
            leading: const Icon(Icons.font_download),
            title: Text(AppLocalizations.of(context)!.editorFont),
            subtitle: Text(AppLocalizations.of(context)!.editorFont_t),
            onTap: () {
              showErrorDialog(
                context,
                "Custom fonts aren't available yet.",
                "Unfortunately, choosing a custom font to use from the device is not"
                    "yet implemented and will not work. This functionality will be added in a future version.",
              );
            },
            enabled: (useMonospace == false),
          ),
          ListTile(
            leading: const Icon(Icons.colorize),
            title: Text(AppLocalizations.of(context)!.colorScheme),
            subtitle: Text(AppLocalizations.of(context)!.selectColorSchemeUsed),
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
                    label: AppLocalizations.of(context)!.close,
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
