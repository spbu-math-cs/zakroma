import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utility/color_manipulator.dart';

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
        onPrimary: Colors.white,
        primaryContainer: Colors.white,
        onPrimaryContainer: Colors.black54,
        secondary: const Color(0xFF983100),
        onSecondary: Colors.white,
        background: Colors.white,
        surface: lighten(orangeBackground, 64),
        onSurface: Colors.black,
        onSurfaceVariant: Colors.black45,
        surfaceTint: Colors.white,
        outline: lighten(orangeBackground, 64),
        shadow: Colors.black26,
      ),
      scaffoldBackgroundColor: orangeBackground,
      dividerColor: lighten(orangeBackground, 30),
      splashColor: Colors.black26,
      highlightColor: Colors.black12,
      splashFactory: InkSplash.splashFactory,
      textTheme: textTheme,
      hoverColor: const Color(0x80B1F2FF),
      // Color(0x00CFF9FF),
    ),
    // ThemeData(
    //     useMaterial3: true,
    //     brightness: Brightness.light,
    //     colorScheme: const ColorScheme.light().copyWith(
    //       primary: paleOrangeBackground,
    //       primaryContainer: Colors.white,
    //       onPrimaryContainer: Colors.black,
    //       secondary: const Color(0xFFA93500),
    //       background: paleOrangeBackground,
    //       surface: const Color(0xFFFCEFE1),
    //       surfaceTint: Colors.transparent,
    //       onSurface: Colors.black,
    //     ),
    //     splashColor: Colors.black26,
    //     highlightColor: Colors.black12,
    //     splashFactory: InkSplash.splashFactory,
    //     textTheme: textTheme),
  ];

  ThemeData getThemeData() => _themeDataList[index];

  AppTheme copyWith(AppTheme theme) => theme;

  AppTheme switchTheme() => AppTheme.values[(index + 1) % AppTheme.values.length];
}

const textTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: 'Preslav'),
  displayMedium: TextStyle(fontFamily: 'Preslav'),
  displaySmall: TextStyle(fontFamily: 'Preslav'),
  headlineLarge: TextStyle(fontFamily: 'VKSansDisplay'),
  headlineMedium: TextStyle(fontFamily: 'VKSansDisplay'),
  headlineSmall: TextStyle(fontFamily: 'VKSansDisplay'),
  titleLarge: TextStyle(fontFamily: 'VKSansDisplay'),
  titleMedium: TextStyle(fontFamily: 'VKSansDisplay'),
  titleSmall: TextStyle(fontFamily: 'VKSansDisplay'),
  labelLarge: TextStyle(fontFamily: 'VKSansDisplay'),
  labelMedium: TextStyle(fontFamily: 'VKSansDisplay'),
  labelSmall: TextStyle(fontFamily: 'VKSansDisplay'),
  bodyLarge: TextStyle(fontFamily: 'VKSansDisplay'),
  bodyMedium: TextStyle(fontFamily: 'VKSansDisplay'),
  bodySmall: TextStyle(fontFamily: 'VKSansDisplay'),
);

const orangeBackground = Color(0xFFFFBA6C);

