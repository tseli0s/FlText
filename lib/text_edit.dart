/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023-2024 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fltext/config.dart';
import 'package:fltext/multiline_text_input.dart';
import 'package:fltext/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextEditor extends StatefulWidget {
  final TextEditingController textController = TextEditingController();
  final String? filename;

  TextEditor({super.key, textController, required this.filename});

  @override
  State<StatefulWidget> createState() => TextEditorState();
}

class TextEditorState extends State<TextEditor> {
  Future<String> readFileContents(String filename) async {
    String text;
    try {
      final File file = File(filename);
      text = await file.readAsString();
    } catch (e) {
      final title = AppLocalizations.of(context)!.errorWhileLoadingFile;
      String message =
          "FlText was unable to read the contents of the file you've opened ($e). Please try again with another file, that uses a supported encoding.";
      showErrorDialog(context, title, message);
      return "";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final Widget b;

    if (widget.filename == null) {
      b = MultilineTextInputWidget(
        controller: widget.textController,
        hintText: AppLocalizations.of(context)!.beginTypingYourTextHere,
      );
    } else {
      b = FutureBuilder(
        future: readFileContents(widget.filename!),
        builder: (ctx, ss) {
          switch (ss.connectionState) {
            case (ConnectionState.none):
              // I don't think this should ever appear,
              // so I won't translate it.
              return const Text("Waiting for data...");
            case (ConnectionState.waiting):
              var loadingCircle = SpinKitFadingCircle(
                color: Color(accentColor),
              );

              return CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context)!.loading),
                content: loadingCircle,
              );

            default:
              if (ss.hasError) {
                final title =
                    AppLocalizations.of(context)!.errorWhileLoadingFile;
                final message =
                    "${AppLocalizations.of(context)!.thereWasAnErrorLoadingFile}${ss.error}";

                showErrorDialog(ctx, title, message);
                Navigator.pop(context);
                return const Text("");
              } else {
                widget.textController.text = ss.data!;
                return MultilineTextInputWidget(
                  controller: widget.textController,
                  hintText:
                      AppLocalizations.of(context)!.beginTypingYourTextHere,
                );
              }
          }
        },
      );
    }

    return Scaffold(
      body: b,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_alt),
        onPressed: () {
          saveFile();
        },
      ),
    );
  }

  void saveFile() async {
    final contents = widget.textController.text;
    String? filename = widget.filename;
    if (filename != null) {
      final f = File(filename);
      f.writeAsString(contents);
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.saveSuccess),
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
    } else {
      String? result = await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.saveFileAt,
        lockParentWindow: true,
      );

      if (result != null) {
        final f = File(result);
        f.writeAsString(contents);
        final snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.saveSuccess),
          padding: const EdgeInsets.all(16.0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.close,
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final title = AppLocalizations.of(context)!.operationCancelled;
        final message = AppLocalizations.of(context)!.noFileWasSelected;
        showErrorDialog(context, title, message);
      }
    }
  }
}
