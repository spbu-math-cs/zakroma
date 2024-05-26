import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/selection.dart';
import 'package:zakroma_frontend/widgets/rr_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../data_cls/user.dart';
import '../../main.dart';
import '../../utility/constants.dart';
import '../../widgets/async_builder.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/flat_list.dart';
import '../../widgets/rr_surface.dart';
import '../../widgets/styled_headline.dart';

// TODO(design): переписать в новом дизайне

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final constants = ref.read(constantsProvider);
    final categoryTextStyle = Theme.of(context).textTheme.headlineMedium;
    // TODO(server): подгружать категории настроек
    final categoryList = [
      'Настройки',
      'Группа',
    ];

    return CustomScaffold(
        header: const CustomHeader(title: 'Профиль'),
        body: SingleChildScrollView(
          child: SizedBox(
            height: constants.paddingUnit * 86,
            child: Column(
              children: [
                Expanded(
                    // Профиль пользователя
                    flex: 16,
                    child: RRSurface(
                      child: Padding(
                        padding: EdgeInsets.all(constants.paddingUnit),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 12,
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(constants.paddingUnit),
                                  child: Center(
                                    child: RRButton(
                                      // TODO: сделать добавление фото из галареи после появления запроса на бэке
                                      onTap: () async {
                                        final image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (image != null) {
                                          //   final user = ref.read(userProvider);
                                          //   ref
                                          //       .read(userProvider.notifier)
                                          //       .updatePic(
                                          //           image.path);
                                          // debugPrint(image.path);
                                          await showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: const Text('Ошибка'),
                                                    content: const Text(
                                                        'К сожалению, на данный момент мы не можем отобразить Ваше фото в профиле :('),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            if (Navigator.of(
                                                                    context)
                                                                .canPop()) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Готово')),
                                                    ],
                                                  ));
                                        }
                                      },
                                      elevation: 0,
                                      borderColor:
                                          Theme.of(context).colorScheme.surface,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(
                                            constants.dInnerRadius),
                                        clipBehavior: Clip.antiAlias,
                                        child: FutureBuilder(
                                            future: ref.watch(
                                                userProvider.selectAsync(
                                                    (user) => user.userPicUrl)),
                                            builder: (_, userPicUrl) => userPicUrl
                                                    .hasData
                                                ? SizedBox.square(
                                                    dimension:
                                                        constants.paddingUnit *
                                                            12,
                                                    child: Image.network(
                                                      userPicUrl.requireData,
                                                      cacheHeight: (constants
                                                                  .paddingUnit *
                                                              12)
                                                          .ceil(),
                                                      cacheWidth: (constants
                                                                  .paddingUnit *
                                                              12)
                                                          .ceil(),
                                                    ),
                                                  )
                                                : const CircularProgressIndicator()),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 26,
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(constants.paddingUnit),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RRButton(
                                      onTap: () {},
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      elevation: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              // Заменить в процессе разработки новой страницы Профиля на более разумное решение
                                              Expanded(
                                                child: AsyncBuilder(
                                                  async: ref.read(userProvider),
                                                  builder: (user) => Text(
                                                    '${user.firstName} ${user.secondName}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Подробнее',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onPrimaryContainer)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: constants.paddingUnit /
                                                        4,
                                                    left:
                                                        constants.paddingUnit /
                                                            2),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size:
                                                      constants.paddingUnit * 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    // Настройки и группа
                    flex: 12,
                    child: RRSurface(
                      child: Column(
                        children: [
                          Expanded(
                              child: RRButton(
                            onTap: () {},
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(constants.dOuterRadius),
                                topRight:
                                    Radius.circular(constants.dOuterRadius)),
                            childAlignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: constants.paddingUnit / 2),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: constants.paddingUnit * 2,
                                        right: constants.paddingUnit),
                                    child: Icon(
                                      Icons.settings_outlined,
                                      size: constants.paddingUnit * 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  Text(
                                    'Настройки',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: RRButton(
                                  onTap: () {},
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          constants.dOuterRadius),
                                      bottomRight: Radius.circular(
                                          constants.dOuterRadius)),
                                  childAlignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: constants.paddingUnit / 2),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: constants.paddingUnit * 2,
                                              right: constants.paddingUnit),
                                          child: Icon(
                                            Icons.group,
                                            size: constants.paddingUnit * 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        Text(
                                          'Группа',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                  )))
                        ],
                      ),
                    )),
                Expanded(
                    // Статистика
                    flex: 20,
                    child: RRSurface(
                        child: Column(
                      children: [
                        Expanded(
                            // Заголовок: «Статистика»
                            flex: 8,
                            child: Padding(
                              padding: constants.dHeadingPadding,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: StyledHeadline(
                                      text: 'Статистика',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                15 * constraints.maxHeight / 16,
                                            height: 1,
                                            leadingDistribution:
                                                TextLeadingDistribution
                                                    .proportional,
                                          )),
                                );
                              }),
                            )),
                        // КБЖУ и ккал
                        // TODO(tech): реализовать горизонтальную прокрутку, индикаторы снизу
                        Expanded(
                          // КБЖУ и диаграмма
                          flex: 15,
                          child: Row(
                            children: [
                              Expanded(
                                  //  Текстовая статистика
                                  child: Padding(
                                    padding: constants.dBlockPadding,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              // Белки
                                              child: Text('100 г - белки',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer))),
                                          Expanded(
                                              // Жиры
                                              child: Text('100 г - жиры',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer))),
                                          Expanded(
                                              // Углеводы
                                              child: Text('100 г - углеводы',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer))),
                                          Expanded(
                                              // ккал
                                              child: Text('2957 ккал',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium!
                                                      .copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ))),
                                        ],
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  // Диаграмма
                                  child: Padding(
                                    padding: constants.dBlockPadding,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                          // Дни недели
                                          children: List<Widget>.generate(
                                        7,
                                        (index) => Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.only(
                                              left: constants.paddingUnit / 2),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors
                                                    .black, // index == Date... ? цвет_выделенный : цвет_обычный,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    constants.dOuterRadius / 5,
                                                  ),
                                                  topRight: Radius.circular(
                                                      constants.dOuterRadius /
                                                          5),
                                                )),
                                          ),
                                        )),
                                      )),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ))),
                Expanded(
                    // Любимые блюда
                    flex: 25,
                    child: RRSurface(
                        child: Column(
                      children: [
                        // Заголовок: «Любимые блюда»
                        Expanded(
                            flex: 7,
                            child: Padding(
                              padding: constants.dHeadingPadding,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: StyledHeadline(
                                      text: 'Любимые блюда',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                15 * constraints.maxHeight / 16,
                                            height: 1,
                                            leadingDistribution:
                                                TextLeadingDistribution
                                                    .proportional,
                                          )),
                                );
                              }),
                            )),
                        // Перечисление рецептов
                        // TODO(tech): реализовать горизонтальную прокрутку, индикаторы снизу
                        Expanded(
                            flex: 18,
                            child: Padding(
                              padding: constants.dBlockPadding -
                                  constants.dCardPadding,
                              child: Row(
                                // TODO(server): подгрузить рецепты (id, название, иконка)
                                // TODO(tech): реализовать recipesProvider?
                                // TODO(tech): использовать генератор списков вместо перечисления
                                children: [
                                  Expanded(
                                      child: RRButton(
                                          onTap: () {},
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          padding: constants.dCardPadding,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  flex: 49,
                                                  child: SizedBox.expand(
                                                    child: Image.asset(
                                                      'assets/images/borsch.jpeg',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 23,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        constants.dLabelPadding,
                                                    child: StyledHeadline(
                                                        text: 'Борщ',
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headlineSmall!
                                                                .copyWith(
                                                                    height: 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                  Expanded(
                                      child: RRButton(
                                          onTap: () {},
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          padding: constants.dCardPadding,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  flex: 49,
                                                  child: SizedBox.expand(
                                                    child: Image.asset(
                                                      'assets/images/potatoes.jpeg',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 23,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        constants.dLabelPadding,
                                                    child: StyledHeadline(
                                                        text: 'Пюре с отбивной',
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headlineSmall),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                  Expanded(
                                      child: RRButton(
                                          onTap: () {},
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          padding: constants.dCardPadding,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  flex: 49,
                                                  child: SizedBox.expand(
                                                    child: Image.asset(
                                                      'assets/images/salad.jpeg',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 23,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        constants.dLabelPadding,
                                                    child: StyledHeadline(
                                                        text:
                                                            'Цезарь с курицей',
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headlineSmall),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                ],
                              ),
                            ))
                      ],
                    ))),
                Expanded(
                    // Выйти из аккаунта
                    flex: 6,
                    child: RRSurface(
                      borderRadius:
                          BorderRadius.circular(constants.dOuterRadius) / 2,
                      child: RRButton(
                        onTap: () async {
                          ref.read(userProvider.notifier).logout();
                          if (!context.mounted) return;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Zakroma()));
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        borderRadius:
                            BorderRadius.circular(constants.dOuterRadius) / 2,
                        child: Text(
                          'Выйти из аккаунта',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
