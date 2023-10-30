import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
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
    final categoryTextStyle = Theme.of(context).textTheme.headlineMedium;
    final categoryList = [
      'Настройки питания',
      'Внешний вид',
      'Напоминания',
      'Способы оплаты',
      'Помощь',
      'Другое',
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: dPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => StyledHeadline(
                      text: 'Настройки',
                      textStyle:
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              ),
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
                          padding: EdgeInsets.all(dPadding.top),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right: constraints.maxWidth -
                                              constraints.maxHeight),
                                      child: Center(
                                        // padding: EdgeInsets.all(defaultPadding.left) + EdgeInsets.only(right: constraints.maxWidth - constraints.maxHeight),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                              dBorderRadius),
                                          clipBehavior: Clip.antiAlias,
                                          elevation: dElevation,
                                          child: SizedBox.square(
                                            dimension:
                                                3 * constraints.maxHeight / 4,
                                            child: Image.asset(
                                              'assets/images/ryan_gosling.jpeg',
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
                                        StyledHeadline(
                                          text: 'Райан Г.',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        StyledHeadline(
                                            text: '185 см',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                        StyledHeadline(
                                          text: '80 кг',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        )),
                    // Группа пользователя
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: StyledHeadline(
                              text: 'Настройки группы',
                              textStyle: categoryTextStyle),
                        ))
                  ],
                ),
              ),
            ),
            // Список настроек
            Expanded(
                flex: 6,
                child: RRSurface(
                    padding: dPadding.copyWith(bottom: dPadding.vertical),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return FlatList(
                          scrollPhysics: const ClampingScrollPhysics(),
                          dividerColor: Theme.of(context).colorScheme.surface,
                          children: List.generate(
                            categoryList.length,
                            (index) => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => {
                                  //TODO
                                },
                                child: StyledHeadline(
                                  text: categoryList[index],
                                  textStyle: categoryTextStyle,
                                ),
                              ),
                            ),
                          ));
                    }))),
          ],
        ),
      ),
    );
  }
}
