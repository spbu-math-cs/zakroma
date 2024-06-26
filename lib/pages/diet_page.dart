import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../utility/constants.dart';

class DietPage extends ConsumerStatefulWidget {
  const DietPage({super.key});

  @override
  ConsumerState createState() => _DietPageState();
}

class _DietPageState extends ConsumerState<DietPage> with RouteAware {
  int selectedDay = 0;
  bool animateFAB = true;
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final constants = ref.read(constantsProvider);
    // TODO(server): подгрузить информацию о рационе, вызвав соотв. метод dietListProvider'а
    final pageController = PageController(initialPage: selectedDay);

    return const Placeholder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    setState(() {
      editMode = false;
    });
  }

  @override
  void didPush() {
    setState(() {
      animateFAB = true;
    });
  }

  @override
  void didPopNext() {
    setState(() {
      animateFAB = true;
    });
  }

  @override
  void didPushNext() {
    setState(() {
      animateFAB = false;
    });
  }
}
