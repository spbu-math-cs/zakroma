import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';
import '../utility/selection.dart';
import 'styled_headline.dart';

class CustomScaffold extends ConsumerWidget {
  final Widget body;
  final Widget? header;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? systemNavigationBarColor;

  const CustomScaffold({
    super.key,
    required this.body,
    this.header,
    this.bottomNavigationBar,
    this.systemNavigationBarColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: systemNavigationBarColor ??
            Theme.of(context).colorScheme.primaryContainer,
        statusBarColor: Colors.transparent));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (context, constraints) => Column(
                  children: [
                    Visibility(
                        visible: header != null,
                        child: Expanded(
                          flex: Constants.topNavigationBarHeight +
                              Constants.headerHeight,
                          child: header != null
                              ? header!
                              : const SizedBox.shrink(),
                        )),
                    Expanded(
                        flex: Constants.screenHeight -
                            Constants.headerHeight -
                            Constants.topNavigationBarHeight,
                        child: body)
                  ],
                )),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
    );
  }
}

class CustomHeader extends ConsumerWidget {
  /// Самый верхний виджет на экране
  ///
  /// Обычно панель навигации с кнопкой «назад».
  /// Если [topNavigationBar] == `null`, то место сверху будет пустым.
  final Widget? topNavigationBar;

  /// Стилизованный заголовок экрана
  ///
  /// Примеры: Закрома, Продукты, Питание, ...
  ///
  /// Если [title] != `null`, то [header] должен быть `null`.
  final String? title;

  /// Заголовок экрана
  ///
  /// На тот случай, когда просто стилизованное слово [title]
  /// это слишком просто.
  ///
  /// Если [header] != `null`, то [title] должен быть `null`.
  final Widget? header;

  /// Верхний виджет в режиме множественного выбора
  ///
  /// При переходе в режим множественного выбора
  /// заменяет собой все верхние виджеты:
  /// и [topNavigationBar], и [title] или [header].
  ///
  /// Если [selectionAppBar] == `null`, то
  /// заголовок никак не реагирует на множественный выбор.
  final Widget? selectionAppBar;

  /// To make empty space for [topNavigationBar] go away,
  /// pass padding with `top: 0` here.
  final EdgeInsets? padding;

  const CustomHeader(
      {super.key,
      this.topNavigationBar,
      this.title,
      this.header,
      this.selectionAppBar,
      this.padding})
      : assert(title == null || header == null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    final defaultLayout = Padding(
      padding: padding ??
          EdgeInsets.only(
              top: topNavigationBar == null
                  ? constants.topPadding +
                      Constants.topNavigationBarHeight * constants.paddingUnit
                  : 0),
      child: Column(
        children: [
          Visibility(
            visible: topNavigationBar != null,
            child: Expanded(
                flex: Constants.topNavigationBarHeight,
                child: topNavigationBar != null
                    ? topNavigationBar!
                    : const SizedBox.shrink()),
          ),
          Visibility(
            visible: title != null,
            child: Expanded(
                flex: Constants.headerHeight,
                child: Padding(
                  padding: ref.watch(constantsProvider).dAppHeadlinePadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: StyledHeadline(
                      text: title!,
                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
    if (selectionAppBar == null) {
      return defaultLayout;
    }
    final selectionModeEnabled = ref.watch(selectionProvider
        .select((value) => value.values.any((element) => element)));
    debugPrint('selectionModeEnabled = $selectionModeEnabled');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: selectionModeEnabled
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent));
    if (selectionModeEnabled) {}
    return selectionModeEnabled ? selectionAppBar! : defaultLayout;
  }
}
