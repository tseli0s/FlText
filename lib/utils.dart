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
import 'package:flutter/cupertino.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showErrorDialog(BuildContext context, String title, String message) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.close),
          )
        ],
      );
    },
  );
}

Future<bool> colorPickerDialog(BuildContext context) async {
  return ColorPicker(
    color: Color(accentColor),
    // Update the dialogPickerColor using the callback.
    onColorChanged: (Color color) {
      accentColor = int.parse(color.toString().substring(8, 16), radix: 16);
    },
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    wheelDiameter: 155,
    heading: Text(
      AppLocalizations.of(context)!.selectColor,
      style: Theme.of(context).textTheme.titleSmall,
    ),
    subheading: Text(
      AppLocalizations.of(context)!.selectColorShade,
      style: Theme.of(context).textTheme.titleSmall,
    ),
    wheelSubheading: Text(
      AppLocalizations.of(context)!.selectedColorAndShades,
      style: Theme.of(context).textTheme.titleSmall,
    ),
    showMaterialName: true,
    showColorName: true,
    showColorCode: true,
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
    ),
    materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: true,
      ColorPickerType.accent: true,
      ColorPickerType.bw: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
  ).showPickerDialog(
    context,
    transitionBuilder: (BuildContext context, Animation<double> a1,
        Animation<double> a2, Widget widget) {
      final double curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    constraints:
        const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
  );
}
