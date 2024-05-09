import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';
import 'styled_headline.dart';

class CustomScaffold extends ConsumerWidget {
  final String? title;
  final Widget? header;
  final Widget body;
  final EdgeInsets? padding;
  final Widget? topNavigationBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const CustomScaffold({
    super.key,
    required this.body,
    this.padding,
    this.title,
    this.header,
    this.topNavigationBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : assert(title == null || header == null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final topPadding = constraints.maxHeight -
              Constants.screenHeight * constants.paddingUnit +
              (topNavigationBar == null
                  ? Constants.topNavigationBarHeight * constants.paddingUnit
                  : 0);

          return Padding(
            padding: padding ?? EdgeInsets.only(top: topPadding),
            child: Column(
              children: [
                Visibility(
                  visible: topNavigationBar != null,
                  child: Expanded(
                      flex: Constants.topNavigationBarHeight,
                      child: topNavigationBar == null
                          ? const SizedBox.shrink()
                          : topNavigationBar!),
                ),
                Visibility(
                  visible: header != null || title != null,
                  child: Expanded(
                      flex: Constants
                          .headerHeight, // стандартная высота заголовка
                      child: header == null
                          ? title == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: constants.dAppHeadlinePadding,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: StyledHeadline(
                                      text: title!,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                  ),
                                )
                          : header!),
                ),
                Expanded(
                    flex: Constants.screenHeight -
                        Constants.headerHeight -
                        Constants.topNavigationBarHeight,
                    child: body)
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
    );
  }
}
