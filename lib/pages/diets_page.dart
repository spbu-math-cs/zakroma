import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/rr_surface.dart';

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
