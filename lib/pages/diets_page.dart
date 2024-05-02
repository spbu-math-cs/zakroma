import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../pages/diet_page.dart';
import '../utility/async_builder.dart';
import '../utility/custom_scaffold.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);

    return CustomScaffold(
      title: 'Питание',
      body: RRSurface(
        child: Padding(
          padding: EdgeInsets.all(constants.paddingUnit * 2),
          child: const Placeholder(),
        ),
      ),
    );
  }
}
