import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/pair.dart';
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
    final categoryTextStyle = Theme.of(context).textTheme.headlineMedium;
    final categoryList = ['Настройки питания',
      'Внешний вид',
      'Напоминания',
      'Способы оплаты',
      'Помощь',
      'Другое',
    ];
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
                      horizontalAlignment: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
            // Профиль пользователя и его группы
            Expanded(
              flex: 4,
              child: RRSurface(
                child: Column(
                  children: [
                    // Профиль пользователя
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(defaultPadding.top),
                          child: Row(
                            children: [
                            Expanded(
                                flex: 1,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: constraints.maxWidth - constraints.maxHeight),
                                      child: Center(
                                        // padding: EdgeInsets.all(defaultPadding.left) + EdgeInsets.only(right: constraints.maxWidth - constraints.maxHeight),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          clipBehavior: Clip.antiAlias,
                                          elevation: defaultElevation,
                                          child: SizedBox.square(
                                            dimension: 3 * constraints.maxHeight / 4,
                                            child: Image.asset(
                                              'assets/images/ryan_gosling.jpeg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                )
                            ),
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
                          ],),
                        )),
                    // Группа пользователя
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: formatHeadline('Настройки группы', categoryTextStyle),
                        ))
                  ],
                ),
              ),
            ),
            // Список настроек
            Expanded(
                flex: 6,
                child: RRSurface(
                    padding: defaultPadding.copyWith(bottom: defaultPadding.vertical),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return FlatList(
                        scrollPhysics: const ClampingScrollPhysics(),
                        childAlignment: Alignment.centerLeft,
                        children: List.generate(categoryList.length, (index) => Pair(
                              formatHeadline(
                                  categoryList[index], categoryTextStyle,),
                              null),),
                          defaultChildConstraints: BoxConstraints(
                              maxWidth: constraints.maxWidth,
                              maxHeight: constraints.maxHeight / 6),
                          dividerColor: lighten(
                              Theme.of(context).colorScheme.background));
                    }))),
          ],
        ),
      ),
    );
  }
}
