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
        body: Column(
          children: [
            // Профиль пользователя
            Expanded(
                flex: 16,
                child: RRSurface(
                  child: Padding(
                    padding: EdgeInsets.all(constants.paddingUnit),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 12,
                            child: Padding(
                              padding: EdgeInsets.all(constants.paddingUnit),
                              child: Center(
                                child: RRButton(
                                  // TODO: сделать добавление фото из галареи после появления запроса на бэке
                                  onTap: () async {
                                    final image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child:
                                                          const Text('Готово')),
                                                ],
                                              ));
                                    }
                                  },
                                  elevation: 0,
                                  foregroundDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constants.dInnerRadius),
                                    border: Border.all(
                                        width: constants.paddingUnit / 4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                  ),
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
                                                    constants.paddingUnit * 12,
                                                child: Image.network(
                                                  userPicUrl.requireData,
                                                  cacheHeight:
                                                      (constants.paddingUnit *
                                                              12)
                                                          .ceil(),
                                                  cacheWidth:
                                                      (constants.paddingUnit *
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
                              padding: EdgeInsets.all(constants.paddingUnit),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RRButton(
                                  onTap: () {},
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  elevation: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                // text: 'Дима Sherem.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
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
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: constants.paddingUnit / 4,
                                                left:
                                                    constants.paddingUnit / 2),
                                            child: Icon(
                                              Icons.info_outline,
                                              size: constants.paddingUnit * 2,
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
            // Список настроек
            Expanded(
                flex: 12,
                child: RRSurface(
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
                      )),
                )),
            Expanded(
                flex: 18,
                child: IconButton(
                    onPressed: () async {
                      ref.read(userProvider.notifier).logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Zakroma()));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.onSurface,
                    ))),
            const Expanded(flex: 25, child: RRSurface(child: Placeholder())),
          ],
        ));
  }
}
