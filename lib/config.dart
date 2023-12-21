/*
 * FlText: A simple and nice-looking text editor.
 * Copyright (C) 2023 Aggelos Tselios
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
import 'package:shared_preferences/shared_preferences.dart';

String recent_0 = "";
String recent_1 = "";
String recent_2 = "";
bool firstLaunch = true;
int accentColor = 0xFF0B95FF;

void loadConfig() async {
  final config = await SharedPreferences.getInstance();

  recent_0 = config.getString('recent_0') ?? "";
  recent_1 = config.getString('recent_1') ?? "";
  recent_2 = config.getString('recent_2') ?? "";
  firstLaunch = config.getBool(
        'firstLaunch',
      ) ??
      true; // If the value doesn't exist, it's probably the first launch
  accentColor = config.getInt('accentColor') ?? accentColor;
}

void addRecent(String filename) {
  /*
   * If a slot is available, find it and set the filename there...
   */
  if (recent_0 == "") {
    recent_0 = filename;
  } else if (recent_1 == "") {
    recent_1 = filename;
  } else if (recent_2 == "") {
    recent_2 = filename;
    /*
     * Otherwise, just push everything down one row, and use the uppermost one
     * as the filename...
     */
  } else {
    recent_2 = recent_1;
    recent_1 = recent_0;
    recent_0 = filename;
  }
  // Finally save the changes to persist between app restarts.
  saveConfigChanges();
}

void clearRecents() async {
  recent_2 = "";
  recent_1 = "";
  recent_0 = "";
  saveConfigChanges();
}

void saveConfigChanges() async {
  final config = await SharedPreferences.getInstance();

  config.setInt('accentColor', accentColor);
  config.setBool('firstLaunch', false);
  config.setString('recent_0', recent_0);
  config.setString('recent_1', recent_1);
  config.setString('recent_2', recent_2);
}
