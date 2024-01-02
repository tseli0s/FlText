/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023-2024 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInputDialog {
  static Future<String?> showTextInputDialog(
    BuildContext context, {
    String? initialValue,
    String informatoryText = '',
    String title = 'Enter text',
  }) async {
    String? inputText = initialValue;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(informatoryText),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    inputText = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(inputText);
              },
            ),
          ],
        );
      },
    );
  }
}
