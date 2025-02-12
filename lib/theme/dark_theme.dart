// import 'package:flutter/material.dart';

// ThemeData dark = ThemeData(
//   fontFamily: 'TitilliumWeb',
//   primaryColor: const Color(0xFF1455AC),
//   brightness: Brightness.dark,
//   highlightColor: const Color(0xFF252525),
//   hintColor: const Color(0xFFc7c7c7),
//   cardColor: const Color(0xFF242424),
//   scaffoldBackgroundColor: const Color(0xFF000000),
//   splashColor: Colors.transparent,
//   colorScheme: const ColorScheme.dark(
//     primary: Color(0xFF1455AC),
//     secondary: Color(0xFF78BDFC),
//     tertiary: Color(0xFF865C0A),
//     tertiaryContainer: Color(0xFF6C7A8E),
//     surface: Color(0xFF2D2D2D),
//     onPrimary: Color(0xFFB7D7FE),
//     onTertiaryContainer: Color(0xFF0F5835),
//     primaryContainer: Color(0xFF208458),
//     onSecondaryContainer: Color(0x912A2A2A),
//     outline: Color(0xff2C66B4),
//     onTertiary: Color(0xFF545252),
//     secondaryContainer: Color(0xFFF2F2F2),
//   ),
//   textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xFFE9EEF4))),
//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.android: ZoomPageTransitionsBuilder(),
//     TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
//     TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
//   }),
// );
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: const Color(0xFF3CB67D), // Updated primary color
  brightness: Brightness.dark,
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFADADAD), // Updated to match secondary color
  cardColor: const Color(0xFF242424),
  scaffoldBackgroundColor: const Color(0xFF000000),
  splashColor: Colors.transparent,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3CB67D), // Updated primary color
    secondary: Color(0xFFDDF9EB), // Updated secondary color
    tertiary: Color(0xFF9AECC6), // Optional: update if needed
    tertiaryContainer: Color(0xFFADC9F3), // Optional: update if needed
    surface: Color(0xFF2D2D2D), // Surface color
    onPrimary: Color(0xFFB7D7FE), // Updated to match text color on primary
    onSecondary: Color(0xFF263C51), // Updated to text color on secondary
    onTertiaryContainer: Color(0xFF0F5835), // Optional: update if needed
    primaryContainer: Color(0xFF208458), // Optional: update if needed
    secondaryContainer: Color(0xFFADADAD), // Updated secondary container color
    outline: Color(0xFF3CB67D), // Keep outline color
    onTertiary: Color(0xFF545252), // Optional: update if needed
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE9EEF4)), // Keep text color as is
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
