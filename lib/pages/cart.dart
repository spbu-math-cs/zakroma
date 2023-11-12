import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';

import '../constants.dart';
import '../utility/custom_scaffold.dart';
import '../utility/navigation_bar.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    return CustomScaffold(
      body: Column(
        children: [
          // Заголовок экрана: «Корзина»
          Expanded(
            flex: 9,
            child: Padding(
              padding: constants.dAppHeadlinePadding,
              child: Align(
                alignment: Alignment.topLeft,
                child: StyledHeadline(
                  text: 'Корзина',
                  textStyle: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ),
          Expanded(
            flex: Constants.screenHeight - 9,
            child: RRSurface(
                child: Stack(children: [
              FlatList(
                  separator: FlatListSeparator.rrBorder,
                  padding: EdgeInsets.symmetric(
                      horizontal: constants.paddingUnit * 2),
                  children: const [
                    Center(child: Text('Огурцы')),
                    Center(child: Text('Помидоры')),
                    Center(child: Text('Лук')),
                    Center(child: Text('Огурцы')),
                    Center(child: Text('Помидоры')),
                    Center(child: Text('Лук')),
                    Center(child: Text('Огурцы')),
                    Center(child: Text('Помидоры')),
                    Center(child: Text('Лук')),
                  ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: constants.paddingUnit * 8,
                  child: RRButton(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Внимание!'),
                                  content: const Text(
                                      'Вы будете перенаправлены в приложение Яндекс для оформления заказа продуктов.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Назад'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Clipboard.setData(const ClipboardData(
                                            text:
                                                'Закажи в лавке Огурцы короткоплодные Кураж Выборжец, помидоры, лук.'));
                                        await LaunchApp.openApp(
                                            androidPackageName:
                                                'com.yandex.searchapp',
                                            iosUrlScheme: 'https://www.icloud.com/shortcuts/560f8b7b038641519796c3311b01cd85',
                                            appStoreLink:
                                                'https://apps.apple.com/us/app/%D1%8F%D0%BD%D0%B4%D0%B5%D0%BA%D1%81-%D1%81-%D0%B0%D0%BB%D0%B8%D1%81%D0%BE%D0%B9/id1050704155',
                                            openStore: true);
                                      },
                                      child: const Text('Продолжить'),
                                    ),
                                  ],
                                ));
                      },
                      borderRadius: constants.dInnerRadius,
                      padding: constants.dBlockPadding,
                      child: Text(
                        'Перейти к оформлению',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ])),
          )
        ],
      ),
      bottomNavigationBar: FunctionalBottomBar(
        selectedIndex: -1, // никогда не хотим выделять никакую кнопку
        destinations: [
          CNavigationDestination(
            icon: Icons.arrow_back,
            label: 'Назад',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          // TODO: заменить кнопку на что-то осмысленное
          CNavigationDestination(
            icon: Icons.edit_outlined,
            label: 'Редактировать',
            onTap: () => {},
          ),
          CNavigationDestination(
            icon: Icons.more_horiz,
            label: 'Опции',
            onTap: () {
              // TODO: показывать всплывающее окошко со списком опций (см. черновики/figma)
            },
          ),
        ],
      ),
    );
  }
}
