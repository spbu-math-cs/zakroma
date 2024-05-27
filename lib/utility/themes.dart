import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'color_manipulator.dart';

part 'themes.g.dart';

@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  AppTheme build() => AppTheme.orangeLight;

  ThemeData getThemeData() => state.getThemeData();

  AppTheme getTheme() => state;

  void setTheme(AppTheme appTheme) {
    state = appTheme;
  }
}

enum AppTheme {
  orangeLight;

  static final _backgroundColors = [
    const Color(0xFFFFBA6C), // orangeLight
  ];

  static final _themeDataList = [
    ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
          onPrimary: Colors.white,
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.black54,
          secondary: const Color(0xFF983100),
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onSurfaceVariant: Colors.black45,
          outline: const Color(0xFFFFE6CA),
          surfaceTint: Colors.white,
          shadow: Colors.black26,
        ),
        splashColor: Colors.black26,
        highlightColor: Colors.black12,
        textTheme: const TextTheme().apply(bodyColor: Colors.black)),
  ];

  ThemeData getThemeData() => _themeDataList[index].copyWith(
        colorScheme: _themeDataList[index].colorScheme.copyWith(
              primary: _backgroundColors[index],
              surface: lighten(_backgroundColors[index], 64),
              outline: lighten(_backgroundColors[index], 64), // FFE6CA
            ),
        scaffoldBackgroundColor: _backgroundColors[index],
        dividerColor: lighten(_backgroundColors[index], 32),
        splashFactory: InkSplash.splashFactory,
        textTheme: _themeDataList[index].textTheme.copyWith(
              displayLarge: _themeDataList[index]
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontFamily: 'Preslav'),
              displayMedium: _themeDataList[index]
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontFamily: 'Preslav'),
              displaySmall: _themeDataList[index]
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontFamily: 'Preslav'),
              headlineLarge: _themeDataList[index]
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              headlineMedium: _themeDataList[index]
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              headlineSmall: _themeDataList[index]
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              titleLarge: _themeDataList[index]
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              titleMedium: _themeDataList[index]
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              titleSmall: _themeDataList[index]
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              labelLarge: _themeDataList[index]
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              labelMedium: _themeDataList[index]
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              labelSmall: _themeDataList[index]
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              bodyLarge: _themeDataList[index]
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              bodyMedium: _themeDataList[index]
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
              bodySmall: _themeDataList[index]
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontFamily: 'VKSansDisplay'),
            ),
      );
}
