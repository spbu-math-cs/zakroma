import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/pages/diet_detail.dart';
import 'package:zakroma_frontend/utility/collect_diets.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

import '../utility/color_manipulator.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  @override
  Widget build(BuildContext context) {
    final dietList = collectDiets();

    final dietTextStyle = Theme.of(context).textTheme.headlineMedium;
    final dietBackgroundColor =
        lighten(Theme.of(context).colorScheme.background, 50);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: defaultPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => formatHeadline(
                      'Рационы',
                      Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 3 * constraints.maxHeight / 4,
                          ),
                      horizontalAlignment: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
            // Текущий рацион
            Expanded(
              flex: 4,
              child: RRSurface(
                child: RRButton(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: dietBackgroundColor,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DietDetailPage(diet: dietList[0])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: formatHeadline(dietList[0].name, dietTextStyle,
                          overflow: TextOverflow.ellipsis),
                    )),
              ),
            ),
            // Список всех рационов
            Expanded(
              flex: 16,
              child: RRSurface(
                padding:
                    defaultPadding.copyWith(bottom: defaultPadding.vertical),
                // continuous: true,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.only(top: defaultPadding.top + 8),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ListView.builder(
                              // вычитаем единичку, потому что dietList[0] ушёл в текущий рацион
                              itemCount: dietList.length - 1,
                              itemBuilder: (context, index) => SizedBox(
                                    height: constraints.maxHeight / 4,
                                    child: RRButton(
                                        backgroundColor: dietBackgroundColor,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DietDetailPage(diet: dietList[index + 1])));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: formatHeadline(
                                              dietList[index + 1].name,
                                              dietTextStyle,
                                              overflow: TextOverflow.ellipsis),
                                        )),
                                  ));
                        }),
                      ),
                    ),
                    // Кнопки
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, -2))
                              ]),
                          child: Row(
                            children: [
                              // Кнопка «поделиться»
                              Expanded(
                                  flex: 1,
                                  child: RRButton(
                                    backgroundColor: dietBackgroundColor,
                                    decoration: const BoxDecoration(),
                                    padding: defaultPadding.copyWith(right: 0),
                                    onTap: () {
                                      debugPrint('42');
                                    },
                                    child: const Icon(Icons.ios_share),
                                  )),
                              // Кнопка «изменить»
                              Expanded(
                                flex: 3,
                                child: RRButton(
                                    backgroundColor: dietBackgroundColor,
                                    decoration: const BoxDecoration(),
                                    onTap: () {
                                      debugPrint('42');
                                    },
                                    child: formatHeadline(
                                        'Изменить', dietTextStyle)),
                              )
                            ],
                          ),
                        ))
                  ],
                  // children: List.generate(
                  //     dietList.length,
                  //     (index) => SizedBox(
                  //       height: constraints.maxHeight / 6,
                  //       child: RRButton(
                  //         onTap: () {
                  //           debugPrint('42');
                  //         },
                  //         backgroundColor: lighten(Theme.of(context).colorScheme.background, 25),
                  //           child: formatHeadline(
                  //               dietList[index], dietTextStyle)),
                  //     )
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
