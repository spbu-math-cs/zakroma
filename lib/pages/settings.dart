import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

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
                                        return Center(
                                          child: SizedBox.square(
                                            dimension:
                                                3 * constraints.maxWidth / 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration:
                                                    shadowsBoxDecoration,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          borderRadius),
                                                  child: Image.asset(
                                                    'assets/images/ryan_gosling.jpg',
                                                  ),
                                                ),
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
                                  constraints: constraints,
                                  text: 'Настройки группы');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints,
                                  text: 'Способы оплаты');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints,
                                  text: 'Напоминания');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints,
                                  text: 'Напоминания');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
                            }),
                          ),
                          Flexible(
                            flex: 1,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SettingsCategory(
                                  constraints: constraints, text: 'Другое');
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
  final BoxConstraints constraints;
  final String text;

  const SettingsCategory(
      {super.key, required this.constraints, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth,
      child: RRSurface(
        backgroundColor: lighten(Theme.of(context).colorScheme.background, 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              formatHeadline(text, Theme.of(context).textTheme.headlineSmall),
        ),
      ),
    );
  }
}
