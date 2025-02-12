// import 'package:flutter/material.dart';

// ThemeData light({Color? primaryColor, Color? secondaryColor})=> ThemeData(
//   fontFamily: 'TitilliumWeb',
//   primaryColor: primaryColor ?? const Color(0xFF1455AC),
//   brightness: Brightness.light,
//   highlightColor: Colors.white,
//   hintColor: const Color(0xFF9E9E9E),
//   splashColor: Colors.transparent,
//   colorScheme:  ColorScheme.light(
//     primary: const Color(0xFF1455AC),
//     secondary: const Color(0xFF004C8E),
//     tertiary: const Color(0xFFF9D4A8),
//     tertiaryContainer: const Color(0xFFADC9F3),
//     onTertiaryContainer: const Color(0xFF33AF74),
//     onPrimary: const Color(0xFF7FBBFF),
//     surface: const Color(0xFFF4F8FF),
//     onSecondary: secondaryColor ?? const Color(0xFFF88030),
//     error: const Color(0xFFFF5555),
//     onSecondaryContainer: const Color(0xFFF3F9FF),
//     outline: const Color(0xff2C66B4),
//     onTertiary: const Color(0xFFE9F3FF),

//     primaryContainer: const Color(0xFF9AECC6),secondaryContainer: const Color(0xFFF2F2F2),),

//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//     TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
//     TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
//   }),
// );
import 'package:flutter/material.dart';

ThemeData light({Color? primaryColor, Color? secondaryColor}) => ThemeData(
      fontFamily: 'TitilliumWeb',
      primaryColor: const Color(0xFF3CB67D), // Updated primary color
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.transparent),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      hintColor:
          const Color(0xFFADADAD), // Updated hint color to match secondary
      disabledColor:
          const Color(0xFFADADAD), // Updated disabled color to match secondary
      canvasColor: const Color(0xFFFFFFFF), // Background color
      cardColor: const Color(0xFFFFFFFF), // Card color
      splashColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        error: Color(0xFFFF5A5A), // Keep error color as is
        primary: Color(0xFF3CB67D), // Updated primary color
        secondary: Color(0xFFDDF9EB), // Updated secondary color
        tertiary: Color(0xFF9AECC6), // Optional: update if needed
        tertiaryContainer: Color(0xFFADC9F3), // Optional: update if needed
        onTertiaryContainer: Color(0xFF33AF74), // Optional: update if needed
        primaryContainer: Color(0xFF9AECC6), // Optional: update if needed
        secondaryContainer:
            Color(0xFFADADAD), // Updated secondary container color
        surface: Color(0xFFFFFFFF), // Surface color
        surfaceTint: Color(0xFF3CB67D), // Updated surface tint to match primary
        onPrimary: Color(0xFF263C51), // Updated to text color
        onSecondary: Color(0xFF263C51), // Updated to text color
      ),

      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      }),
    );
