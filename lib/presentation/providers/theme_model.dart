import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  bool isDarkTheme = false;

   ThemeMode currentTheme() {
    return isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
