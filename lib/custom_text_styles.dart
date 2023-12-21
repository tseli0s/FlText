/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TitleText extends StatefulWidget {
  String _text = "";

  TitleText({super.key, required String text}) {
    _text = text;
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => TitleTextState();
}

class TitleTextState extends State<TitleText> {
  final textStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      widget._text,
      style: textStyle,
    );
  }
}
