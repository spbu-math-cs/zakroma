import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/custom_scaffold.dart';

class MarketPage extends ConsumerWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScaffold(
        header: CustomHeader(title: 'Корзина'), body: Placeholder());
  }
}
