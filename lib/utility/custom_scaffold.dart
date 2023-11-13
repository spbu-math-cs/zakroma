import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';

import 'styled_headline.dart';

class CustomScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          debugPrint('maxHeight = ${constraints.maxHeight}');
          final topPadding = constraints.maxHeight -
              Constants.screenHeight * constants.paddingUnit;
          debugPrint('topPadding = ${topPadding.toString()}');
          return Padding(
            padding: EdgeInsets.only(top: topPadding > 0 ? topPadding : 0),
            child: title == null
                ? body
                : Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: constants.dAppHeadlinePadding,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: StyledHeadline(
                              text: title!,
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: Constants.screenHeight - 9, child: body)
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
