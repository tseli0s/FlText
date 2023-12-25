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
import 'package:flutter/material.dart';

class MultilineTextInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const MultilineTextInputWidget({
    super.key,
    required this.controller,
    this.hintText = "",
  });

  @override
  // ignore: library_private_types_in_public_api
  _MultilineTextInputWidgetState createState() =>
      _MultilineTextInputWidgetState();
}

class _MultilineTextInputWidgetState extends State<MultilineTextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: widget.controller,
        maxLines: null,
        style: TextStyle(fontFamily: useMonospace ? "monospace" : null),
        decoration: InputDecoration.collapsed(
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
