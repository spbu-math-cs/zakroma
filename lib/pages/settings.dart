import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/custom_scaffold.dart';

import '../constants.dart';
import '../utility/flat_list.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

// TODO: загружать пользовательские данные (аватарку, имя, ...) и настройки откуда-то

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final categoryTextStyle = Theme.of(context).textTheme.headlineMedium;
    final categoryList = [
      'Настройки питания',
      'Внешний вид',
      'Напоминания',
      'Способы оплаты',
      'Помощь',
      'Другое',
    ];

    return CustomScaffold(
      title: 'Настройки',
      body: Column(
        children: [
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
                                        borderRadius:
                                            BorderRadius.circular(constants.dOuterRadius),
                                        clipBehavior: Clip.antiAlias,
                                        elevation: constants.dElevation,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
