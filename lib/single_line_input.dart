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
