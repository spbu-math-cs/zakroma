import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

import '../utility/color_manipulator.dart';

// TODO: загружать пользовательские данные (аватарку, имя, ...) и настройки откуда-то

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: defaultPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => formatHeadline(
                      'Настройки',
                      Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 3 * constraints.maxHeight / 4,
                          ),
                      TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: RRSurface(
                  continuous: true,
                  padding: defaultPadding.copyWith(bottom: 0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: defaultPadding.copyWith(left: 0, right: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // аватарка и данные пользователя
                          Flexible(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: defaultPadding.top) + EdgeInsets.all(defaultPadding.top),
                                          child: Container(
                                            decoration:
                                                shadowsBoxDecoration,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadius),
                                              clipBehavior: Clip.antiAlias,
                                              child: Image.asset(
                                                'assets/images/ryan_gosling.jpeg',
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            formatHeadline(
                                              "Райан Г.",
                                              Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            formatHeadline(
                                                "185 см",
                                                Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                            formatHeadline(
                                              "80 кг",
                                              Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              )),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Настройки группы');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Способы оплаты');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Напоминания');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Напоминания');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  width: constraints.maxWidth,
                                  text: 'Другое');
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// TODO: сделать кликабельной, как статус-бары на homepage
class SettingsCategory extends StatelessWidget {
  final double width;
  final String text;

  const SettingsCategory(
      {super.key, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    final categorySize = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewPadding.top) /
        12;
    final dividerPadding = width / 10;
    return SizedBox(
      height: categorySize,
      width: width,
      child: Column(
          children: [
        Expanded(
          flex: 20,
          child: Padding(
            padding: EdgeInsets.fromLTRB(dividerPadding * 1.5, 0, 0, 8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: formatHeadline(
                  text, Theme.of(context).textTheme.headlineMedium),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dividerPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  color: lighten(Theme.of(context).colorScheme.background, 25),

                ),
              ),
            )
        )
      ]),
    );
  }
}
