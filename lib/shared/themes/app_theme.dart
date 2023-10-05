import 'package:flutter/material.dart';

import '../../presentation/providers/theme_model.dart';

class AppTheme{

  // Color Palette
  static const Color primaryColor = Color(0xFF4FAEAE); // Example value for muted teal
  static const Color secondaryColor = Color(0xFFFFA1A1); // Example value for pastel coral
  static const Color accentColor = Color(0xFFD1A7E2); // Example value for gentle lavender
  static const Color errorColor = Color(0xFFFFB6C1); // Example value for muted rose
  static const Color backgroundColor = Color(0xFFF5F5F5); // Example value for off-white
  static Color iconColor = Colors.grey.shade500; // Example value for black

  ThemeModel themeModel = ThemeModel();

  // Typography
  static TextStyle primaryTextStyle = const TextStyle(
    fontFamily: 'Merriweather',
    fontSize: 16,
    color: primaryColor,
  );

  static TextStyle appBarTextStyleLightMode = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: 1.2,
    fontFamily: 'Lato',  // You can change this to any font you've imported
  );

  static TextStyle appBarTextStyleDarkMode = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.2,
    fontFamily: 'Lato',  // You can change this to any font you've imported
  );

  static TextStyle secondaryTextStyle = const TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    color: secondaryColor,
  );

  static TextStyle titleText = const TextStyle(
    fontFamily: 'Merriweather',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

 static TextStyle dateText = const TextStyle(
    fontFamily: 'Merriweather',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    // check if dark or light mode and change color accordingly
    color: Colors.white,
 );

  static TextStyle editorTextStyle = const TextStyle(
    fontFamily: 'Merriweather',
    fontSize: 18,
    color: secondaryColor,
  );

  // Theme Data
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    errorColor: errorColor,
    backgroundColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Lato', // Default font family
    textTheme: TextTheme(
      bodyText1: primaryTextStyle,
      bodyText2: secondaryTextStyle,
      headline1: secondaryTextStyle.copyWith(fontSize: 24), // Just as an example
      // ... Add other text styles as needed
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    // ... Add other theme data as needed
  );

}