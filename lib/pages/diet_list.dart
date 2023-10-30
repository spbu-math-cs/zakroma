import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/pages/diet_display.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final dietList = ref.watch(NotifierProvider<DietList, List<Diet>>(DietList.new));

    final dietTextStyle = Theme.of(context).textTheme.headlineMedium;
    final dietBackgroundColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                      text: 'Рационы',
                      textStyle:
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              ),
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
                    dPadding.copyWith(bottom: dPadding.vertical),
                child: Padding(
                  padding: EdgeInsets.only(top: dPadding.top),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return ListView.builder(
                        itemCount: dietList.length,
                        itemBuilder: (context, index) => SizedBox(
                              height: constraints.maxHeight / 5,
                              child: RRButton(
                                  foregroundDecoration: index == 0
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              dBorderRadius),
                                          border: Border.all(
                                              width: 4,
                                              color: Color.alphaBlend(
                                                  const Color(0xffe36942)
                                                      .withOpacity(0.5),
                                                  dietBackgroundColor)),
                                        )
                                      : null,
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
                                    child: StyledHeadline(
                                      text: dietList[index].name,
                                      textStyle: dietTextStyle,
                                    ),
                                  )),
                            ));
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
