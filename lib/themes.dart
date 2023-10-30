import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';

final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(() {
  return ThemeNotifier();
});

enum AppTheme {
  orangeLight,
  paleOrangeLight;

  static final _themeDataList = [
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light().copyWith(
        primary: orangeBackground,
        primaryContainer: Colors.white,
        onPrimaryContainer: Colors.black,
        secondaryContainer: Colors.white,
        onSecondaryContainer: Colors.black38,
        // secondary: const Color(0xFFA14524),
        // secondary: const Color(0xFFE36942),
        secondary: const Color(0xFFA93500),
        background: Colors.white,
        surface: lighten(orangeBackground, 55),
        onSurface: Colors.black,
        onSurfaceVariant: lighten(orangeBackground, 15),
        surfaceTint: Colors.white,
        shadow: Colors.black26,
      ),
      splashColor: Colors.black26,
      highlightColor: Colors.black12,
      splashFactory: InkSplash.splashFactory,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Preslav'),
        displayMedium: TextStyle(fontFamily: 'Preslav'),
        displaySmall: TextStyle(fontFamily: 'Preslav'),
        headlineLarge: TextStyle(fontFamily: 'TinkoffSans'),
        headlineMedium: TextStyle(fontFamily: 'TinkoffSans'),
        headlineSmall: TextStyle(fontFamily: 'TinkoffSans'),
        titleLarge: TextStyle(fontFamily: 'TinkoffSans'),
        titleMedium: TextStyle(fontFamily: 'TinkoffSans'),
        titleSmall: TextStyle(fontFamily: 'TinkoffSans'),
        labelLarge: TextStyle(fontFamily: 'TinkoffSans'),
        labelMedium: TextStyle(fontFamily: 'TinkoffSans'),
        labelSmall: TextStyle(fontFamily: 'TinkoffSans'),
        bodyLarge: TextStyle(fontFamily: 'TinkoffSans'),
        bodyMedium: TextStyle(fontFamily: 'TinkoffSans'),
        bodySmall: TextStyle(fontFamily: 'TinkoffSans'),
      ),
    ),
    ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
          primary: paleOrangeBackground,
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.black,
          // secondary: const Color(0xFFA14524),
          // secondary: const Color(0xFFE36942),
          secondary: const Color(0xFFA93500),
          background: paleOrangeBackground,
          surface: const Color(0xFFFCEFE1),
          surfaceTint: Colors.transparent,
          onSurface: Colors.black,
        ),
        splashColor: Colors.black26,
        highlightColor: Colors.black12,
        splashFactory: InkSplash.splashFactory,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Preslav'),
          displayMedium: TextStyle(fontFamily: 'Preslav'),
          displaySmall: TextStyle(fontFamily: 'Preslav'),
          headlineLarge: TextStyle(fontFamily: 'TinkoffSans'),
          headlineMedium: TextStyle(fontFamily: 'TinkoffSans'),
          headlineSmall: TextStyle(fontFamily: 'TinkoffSans'),
          titleLarge: TextStyle(fontFamily: 'TinkoffSans'),
          titleMedium: TextStyle(fontFamily: 'TinkoffSans'),
          titleSmall: TextStyle(fontFamily: 'TinkoffSans'),
          labelLarge: TextStyle(fontFamily: 'TinkoffSans'),
          labelMedium: TextStyle(fontFamily: 'TinkoffSans'),
          labelSmall: TextStyle(fontFamily: 'TinkoffSans'),
          bodyLarge: TextStyle(fontFamily: 'TinkoffSans'),
          bodyMedium: TextStyle(fontFamily: 'TinkoffSans'),
          bodySmall: TextStyle(fontFamily: 'TinkoffSans'),
        )),
    // ThemeData(
    //   useMaterial3: true,
    //   brightness: Brightness.dark,
    //   colorScheme: const ColorScheme.dark().copyWith(
    //     primary: orangeBackground,
    //     primaryContainer: Colors.white38,
    //     onPrimaryContainer: Colors.white,
    //     // secondary: const Color(0xFFA14524),
    //     // secondary: const Color(0xFFE36942),
    //     secondary: const Color(0xFFA93500),
    //     background: Colors.black87,
    //     surface: lighten(orangeBackground, 55),
    //     surfaceTint: Colors.white,
    //     onSurface: Colors.black,
    //   ),
    //   splashColor: Colors.black26,
    //   highlightColor: Colors.black12,
    //   splashFactory: InkSplash.splashFactory,
    //   textTheme: const TextTheme(
    //     displayLarge: TextStyle(fontFamily: 'Preslav'),
    //     displayMedium: TextStyle(fontFamily: 'Preslav'),
    //     displaySmall: TextStyle(fontFamily: 'Preslav'),
    //     headlineLarge: TextStyle(fontFamily: 'TinkoffSans'),
    //     headlineMedium: TextStyle(fontFamily: 'TinkoffSans'),
    //     headlineSmall : TextStyle(fontFamily: 'TinkoffSans'),
    //     titleLarge: TextStyle(fontFamily: 'TinkoffSans'),
    //     titleMedium: TextStyle(fontFamily: 'TinkoffSans'),
    //     titleSmall: TextStyle(fontFamily: 'TinkoffSans'),
    //     labelLarge: TextStyle(fontFamily: 'TinkoffSans'),
    //     labelMedium: TextStyle(fontFamily: 'TinkoffSans'),
    //     labelSmall: TextStyle(fontFamily: 'TinkoffSans'),
    //     bodyLarge: TextStyle(fontFamily: 'TinkoffSans'),
    //     bodyMedium: TextStyle(fontFamily: 'TinkoffSans'),
    //     bodySmall: TextStyle(fontFamily: 'TinkoffSans'),
    //   ).apply(
    //     bodyColor: Colors.white,
    //     displayColor: Colors.white,
    //   ),
    // ),
  ];

  ThemeData getThemeData() => _themeDataList[index];

  AppTheme copyWith(AppTheme theme) => theme;

  AppTheme switchTheme() =>
      AppTheme.values[(index + 1) % AppTheme.values.length];
}

class ThemeSettings {
  final ThemeData _themeData;

  ThemeSettings(this._themeData);

  ThemeSettings copyWith(ThemeData? themeData) {
    return ThemeSettings(themeData ?? _themeData);
  }

  ThemeData getTheme() => _themeData;
}

class ThemeNotifier extends Notifier<AppTheme> {
  ThemeData getThemeData() => state.getThemeData();

  AppTheme getTheme() => state;

  // ThemeData getTheme() => _currentTheme.getTheme();

  void setTheme(AppTheme appTheme) {
    state = appTheme;
  }

  @override
  AppTheme build() => AppTheme.orangeLight;
}

// const orangeBackground = Color(0xFFFFBA6C);
const orangeBackground = Color(0xFFFFB96C);

// const paleOrangeBackground = Color(0xFFFFB96C);
const paleOrangeBackground = Color(0xFFFFE7CE);
