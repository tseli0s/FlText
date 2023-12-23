/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fltext/custom_text_styles.dart';
import 'package:fltext/settings_screen.dart';
import 'package:fltext/single_line_input.dart';
import 'package:fltext/text_edit.dart';
import 'package:fltext/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fltext/config.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadConfig();
  runApp(const FlText());
}

final githubURL = Uri.parse("https://github.com/tseli0s/FlText");
final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(accentColor),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

// ignore: must_be_immutable
class FlText extends StatelessWidget {
  const FlText({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'FlText',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(accentColor)),
        useMaterial3: true,
      ),
      darkTheme: darkTheme,
      home: const Homepage(title: 'FlText'),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.title});

  final String title;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      if (firstLaunch && Platform.isAndroid) {
        showErrorDialog(
          context,
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.androidWarning,
        );
        saveConfigChanges();
      }
    }
  }

  bool darkTheme = false;

  void setDarkTheme(bool v) {
    setState(() {
      darkTheme = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(accentColor),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (ctx) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(AppLocalizations.of(context)!.aboutFltext),
              onTap: () {
                showAboutDialog(
                  applicationName: "FlText",
                  applicationVersion: "0.1.0",
                  applicationIcon: SizedBox.fromSize(
                    size: const Size.square(48),
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                  children: [
                    Text(AppLocalizations.of(context)!.fltextDesc),
                    TextButton(
                      onPressed: () async {
                        await openURL(githubURL);
                      },
                      child: Text(AppLocalizations.of(context)!.githubRepo),
                    )
                  ],
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleText(text: AppLocalizations.of(context)!.welcomeToFltext),
            Text(
              AppLocalizations.of(context)!.startByEither,
              textAlign: TextAlign.start,
            ),
            TextButton(
              onPressed: () {
                openTextEditor(null);
              },
              child: Text(
                AppLocalizations.of(context)!.creatingAFile,
                textAlign: TextAlign.start,
              ),
            ),
            Text(AppLocalizations.of(context)!.or),
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  dialogTitle: AppLocalizations.of(context)!.selectAFile,
                );
                if (result != null) {
                  if (result.count >= 2) {
                    final title =
                        AppLocalizations.of(context)!.tooManyFilesSelected;
                    final message =
                        AppLocalizations.of(context)!.tooManyFilesSelected_t;
                    showErrorDialog(context, title, message);
                  }
                  String filename = result.files.first.path.toString();
                  openTextEditor(filename);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.openAnExistingFile,
                textAlign: TextAlign.start,
              ),
            ),
            Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              children: [
                if (recent_0 != "")
                  FilledButton(
                    onPressed: () {
                      clearRecents();
                      setState(() {});
                    },
                    child: const Icon(Icons.clear_all),
                  ),
                if (recent_0 != "")
                  const SizedBox(
                    width: 12,
                    height: 2,
                  ),
                TitleText(text: AppLocalizations.of(context)!.recents),
              ],
            ),
            if (recent_0 != "")
              TextButton(
                onPressed: () {
                  openTextEditor(recent_0);
                },
                child: Text(recent_0),
              ),
            if (recent_1 != "")
              TextButton(
                onPressed: () {
                  openTextEditor(recent_1);
                },
                child: Text(recent_1),
              ),
            if (recent_2 != "")
              TextButton(
                onPressed: () {
                  openTextEditor(recent_2);
                },
                child: Text(recent_2),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return TextEditor(filename: null);
              },
            ),
          );
        },
        tooltip: AppLocalizations.of(context)!.newFile,
        child: const Icon(Icons.file_open),
      ),
    );
  }

  void openTextEditor(String? filename) async {
    /*
     * We only need to do this on the following platforms as they don't provide a regular dialog.
     * When the library we use supports them or if we write our own dialog just for this app
     * then this will become useless.
     * Basically this creates a file before editing so that no "save file"
     * dialog is ever needed.
     */
    if (Platform.isAndroid || Platform.isFuchsia || kIsWeb) {
      final result = await TextInputDialog.showTextInputDialog(
        context,
        informatoryText: AppLocalizations.of(context)!.pleaseEnterFilename,
        title: AppLocalizations.of(context)!.filenameTitle,
      );
      if (result != null) {
        final path = await getApplicationDocumentsDirectory();
        filename = '${path.absolute.path}/$result';
        try {
          File(filename).createSync(recursive: false, exclusive: true);
        } catch (e) {
          final title = AppLocalizations.of(context)!.errorCreatingNewFile;
          showErrorDialog(context, title, e.toString());
        }
      } else {
        return; // We'll assume the user didn't want this to open
      }
    }
    if (filename != null) {
      addRecent(filename);
      setState(() {});
    }
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return TextEditor(filename: filename);
        },
      ),
    );
  }

  Future<void> openURL(Uri url) async {
    /* 
     * Like the documentation says, launchUrl may either throw an exception or return false on failure,
     * depending on the error. Here we handle both so we never have to manually debug what went wrong.
     */
    try {
      if (await launchUrl(url) != true) {
        final title = AppLocalizations.of(context)!.unableToOpenURL;
        final msg = AppLocalizations.of(context)!.anUnknownErrorOccured_URL;
        showErrorDialog(context, title, msg);
      }
    } catch (e) {
      final title = AppLocalizations.of(context)!.unableToOpenURL;
      final msg = "Failed to load ${url.toString()}: ${e.toString()}";
      showErrorDialog(context, title, msg);
    }
  }
}
