import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/custom_scaffold.dart';

import '../constants.dart';
import '../utility/flat_list.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

// TODO(design): переписать в новом дизайне

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
    // TODO(server): подгружать категории настроек
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
      body: RRSurface(
        child: Column(
          children: [
            // TODO(server): подгружать данные профиля (имя, аватарку, ...)
            // Профиль пользователя
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(constants.paddingUnit),
                  child: Row(
                    children: [
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: Material(
                              borderRadius:
                                  BorderRadius.circular(constants.dInnerRadius),
                              clipBehavior: Clip.antiAlias,
                              elevation: constants.dElevation,
                              child: SizedBox.square(
                                dimension: constants.paddingUnit * 12,
                                child: Image.asset(
                                  'assets/images/ryan_gosling.jpeg',
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledHeadline(
                              text: 'Райан Г.',
                              textStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            StyledHeadline(
                                text: '185 см',
                                textStyle:
                                    Theme.of(context).textTheme.headlineSmall),
                            StyledHeadline(
                              text: '80 кг',
                              textStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                )),
            // Список настроек
            Expanded(
                flex: 10,
                child: FlatList(
                    scrollPhysics: const ClampingScrollPhysics(),
                    dividerColor: Theme.of(context).colorScheme.surface,
                    children: List.generate(
                      categoryList.length,
                      (index) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => {
                            // TODO(func): переходить в категорию
                          },
                          child: StyledHeadline(
                            text: categoryList[index],
                            textStyle: categoryTextStyle,
                          ),
                        ),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
