import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/data_cls/user.dart';
import 'package:zakroma_frontend/utility/async_builder.dart';
import 'package:zakroma_frontend/utility/custom_scaffold.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../utility/flat_list.dart';
import '../../utility/rr_surface.dart';
import '../../utility/styled_headline.dart';

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
      'Настройки питания',
      'Внешний вид',
      'Напоминания',
      'Способы оплаты',
      'Помощь',
      'Другое',
    ];

    return CustomScaffold(
      title: 'Профиль',
      body: RRSurface(
        child: Column(
          children: [
            // Профиль пользователя
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(constants.paddingUnit),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
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
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AsyncBuilder(
                                asyncValue: ref.read(userProvider),
                                builder: (user) => StyledHeadline(
                                    text:
                                        '${user.firstName ?? ''} ${(user.secondName ?? '')[0]}.',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall)),
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
                      )),
                      Expanded(
                          child: IconButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isAuthorized', false);
                                // TODO(tech): сделать метод user.logout, в котором
                                //  очистить все sharedPreferences при выходе
                                if (!context.mounted) return;
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Zakroma()));
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Theme.of(context).colorScheme.onSurface,
                              ))),
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
