import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/pages/diet.dart';
import 'package:zakroma_frontend/utility/collect_diets.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

import '../utility/color_manipulator.dart';

class DietListPage extends StatefulWidget {
  const DietListPage({super.key});

  @override
  State<DietListPage> createState() => _DietListPageState();
}

class _DietListPageState extends State<DietListPage> {
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
              flex: 1,
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
            // Список всех рационов
            Expanded(
              flex: 10,
              child: RRSurface(
                padding:
                    defaultPadding.copyWith(bottom: defaultPadding.vertical),
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListView.builder(
                      itemCount: dietList.length,
                      itemBuilder: (context, index) => SizedBox(
                            height: constraints.maxHeight / 5,
                            child: RRButton(
                                foregroundDecoration: index == 0
                                    ? BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                        border: Border.all(
                                            width: 3,
                                            color: Color.alphaBlend(
                                                Colors.greenAccent
                                                    .withOpacity(0.3),
                                                dietBackgroundColor)),
                                      )
                                    : null,
                                backgroundColor: dietBackgroundColor,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DietPage(
                                              diet: dietList[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: formatHeadline(
                                      dietList[index].name, dietTextStyle,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
